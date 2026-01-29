Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07EE0D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F266B0089; Thu, 29 Jan 2026 16:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AF66B008A; Thu, 29 Jan 2026 16:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512766B008C; Thu, 29 Jan 2026 16:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7AC6B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:04:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D696113A2C6
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:53 +0000 (UTC)
X-FDA: 84386230866.13.1CD099B
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09A1714000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XVJiZ6oX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFORCx/4rWXlwM5MWzZ4y2ZhtVTmicaaxzmL4W2ym48=;
	b=h3fwPr+3e7UTDXqEWoW8ohsvbbrFfKve66RjLqa82rTDceqXpTqTRo7Vej7eLw2NsfclLf
	aEMZ9siWdK6qnrfwznT72UgVkPM102l/7mqY4Zso/OUTTJnxUFwBPn7d+8tAJZ2by0kDDW
	8fVgFtB1Xr2BBfrQVMQoec3KlWDAsnM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XVJiZ6oX;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720692; a=rsa-sha256;
	cv=none;
	b=hIkm7pHfxLv23SE9oRCOTp1qbKVAClbpQMFN7YBvRgbbbYchV4o4QltpjP6OKWsX3D3+Kf
	0zFJWnXAa8RE7pna9e+4OG5EXbd4ECvZ4XoWy3D7D4hWgjSoeb8pdvzbdS6sEOj+mSb7w9
	NyzAkbnvnxOArVpS+M4Nr1vnaJY5fkM=
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8c532d8be8cso144851385a.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720691; x=1770325491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFORCx/4rWXlwM5MWzZ4y2ZhtVTmicaaxzmL4W2ym48=;
        b=XVJiZ6oXvd6XN9XOlFtSCUQqjQwGWVVXxkl4ograo/0uvimzKAQ2UPS/nEOSbVmrE5
         R4Sdkb8o5KxlmxTqno8UWfgfqqf/5tECTKvo3W3XBa3vxb+JhJBl0yCHjFVkvsDKjrxm
         tMWAOFsA6/2R3f4xqiDr4MOkbgiWUlfbzJt2buqzS8u+kD1YDwZok/X3Wb5hCp3Lh82M
         d0Y1r5Cig8Rn4PfGxnTYAjwJDpxx2HWaqFqOcmIZveAVNCGRafDRHZZhT1kD3N+DtTLn
         xcghZB1b8Apl/kX7GdgtBjshGkCArzQMGuy2sgEKr0nSbt3jkI9GT0ncP2MnnvL258+y
         oa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720691; x=1770325491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jFORCx/4rWXlwM5MWzZ4y2ZhtVTmicaaxzmL4W2ym48=;
        b=OWQa/buYW/O6SZ7RM9clYu0+pPbrDt9uxHFJeQhmONSS9vwRoB65LVq16fsHZhqUrH
         15QdO5MG2FHBQXrZhukgzgGwHFOLOMLQ19OnXzJf93fxSrg4ZHxJDj6QQc3/dIPLzy4a
         1FMtoLQuw6Axixr0PypSQl9bsuwrvKbdiMOUnrl+1Qqfo0RAfILJRXQ8GJtWCIlX62nU
         GczjFnYOOe8GmCI1RoAckQU1bn9NkQGbKki7snf5T88VhBToG9QMBgFRS4RB1pp22FrL
         0pJNpE4+ASHx9AlMNbjJeKijFxrtuidxgBVfDPBtEuJr5fcPB/GYi3yKpHSLeREWXMNF
         yJYg==
X-Gm-Message-State: AOJu0Yzx+RI/lSRS0tygAigIrxWhFSpvitdbxWJUCygptIhj3z3hbR3v
	b12o6u1KdHvF7mUgzZ+ajiAeAcYMijc1YV+ndQuLEDprKu7HTeXv04pOpuAktHspF+XYRe1L+hg
	usS6oFKJDVA==
X-Gm-Gg: AZuq6aKsVhLHrLXpGC2lhA1tk25nmvvB2O1q/P0XdBFkD2wnjuUutce9QKU3HqKBLqg
	OnfxGaNirztKbmzc018LHsLZBM648nhTs+sAsBjDXdeVvtrrivNd36zE6TI4aWW86Q2AFovABqu
	mcH+xbcBQAt2m7xWC47BiqnNX3fkfH5EKrxrBq7XTeAyEHx1Gnn+qmlCEcqEIcwVnQLmDV/m7RP
	FUQGDgqm3hUmNogchggt229gEDzk0ZwxXyedza+CbTt211dNQCxzv7bQyfo5F9f45dlDKJjjnI3
	/+9aLwrnJeBfEQNsz3FCrLjadVLpXlhgO/WlK2Bl3C8uBhScjweP/g0eosSbGjo/6MQJvf32YUX
	xDZ/SMaihITZLJwrS1EyCSrIYyMWoPdFI1sreKScB3Bc7g6uuAdy0AvoWoda1wxEGF4+kzBRMqN
	VkZAMusOl5dBwl+csh2SV56cu0KGc9pMOz6rdG13V5FnbrklHuDJlflFuzl8lLni/RfP76PpvQg
	g8=
X-Received: by 2002:a05:620a:298d:b0:8c5:391f:1db7 with SMTP id af79cd13be357-8c9eb3119c3mr144724885a.64.1769720690713;
        Thu, 29 Jan 2026 13:04:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:50 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH 1/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Thu, 29 Jan 2026 16:04:34 -0500
Message-ID: <20260129210442.3951412-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ncwhbs4jn7xux9nyfyhzehoy4dwd4rpt
X-Rspamd-Queue-Id: 09A1714000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769720691-726702
X-HE-Meta: U2FsdGVkX1/gsytx7tda6O0AVryP3hyD8YBAiSj7ZdDw+MhNlPwfSrtXR69rLOMqAhHV0CrTDry4ZOV4Trz/YPD2dDvN0kcb36UTZ46gicDs/pZ3cgYEteBrIDGlKTMDmBtBNVrNqpk3hSTxwiMvl51XuQuInWk/TUoj/t405eTtayFaCEUK27kHVy5+LZ6Cg/62chBDWvh/t3IqmsP02P8Meuj7Cv5BlfTIJKSpGXZg6WbEr6BTjUgAHY/+KQgWn+Ngd3eKh36VaYuPlUr9BbxACA+voiD3RB+eFU5WkeV/mwZcxKJVCQgIz8nr36tO5/Wwq0Gdxtgo8WDx3vhIcKtGq+qUY4mFw47GXIUiPEBBtiLGTxTRO/uj/zPKS6UntaHdToks9iD/8k/AnkObTRyqbBUpGzcBFx1cWYVBuKnGNkqkIG4kNeuq+l/3oXuMOreicyEavT0EXwHI5SYL1HmR93ZkqR9We/0uMw4xUlQC2XbmbmSfIXfzjyZ+FSP5JRpOZn8bJErtPE5GF9Uyc8GvUQ5ETrgH/B8L/kA7Fwzj8HXRw7MIP/mdmdslA0XrtEPmk45NAdGkQZCqmehx0x07q23vde2mndUOMLvajUub8RoTFn8MJ+/zTxkPZ3Q07Gmyfa7ifSBKrtYeqmXf2MobvKMLazRiFxwr5NmHRKSYgb70fCVdkieex2HNdH+sW+f8JjMp4oIrssOSzDQ0D1K1y17E4ziUpbRo1EIuqtP2z6gBrv3Apm2Ej9DmPv9dWwKOdhrZ/sql9nar74nWzznPrYGu/RtYq0LWx6FjIG+QGl63mbGx77pISgtVoGnfQlLpeyKl1Llsw2+lseTu2BO/wLuKvMvYCzpAa8NU1nK1OaRksAzjyOoILlaIvVnmW+pz9ntK73N/lR9KCxVqJ1xHiyz7sR5JDellR90r15UeMN8MTfw2jXu7CUWQItKyc9ITbyuDzkwL0DasRiv
 giZEujEl
 Wvaq3Amuqh3xZWs7Dh5q4FqngOS0Qfeb97yKiqVR8hGJ4eq7JITQXphdo8HiV3xQw2mtcxkbmsoVgmrCl/C7G8atWoylR63UlcPSatdgUBNv2fOsVmQ3TjkxkjSPqyWjqhKvE4Yu6o+WeRLzQq5fVEJrwxORY89Zq6B3UWFEKCUq3nvUzwZcp+Alugn5gAhoR/Mdmd/9wBA8ijt4dek5xkwBHixlmama7wSzV1IRlBfSdMnJ87r7wGGbYi2F184LJ54HYfff32pn0PNSHepnJm45knrE061ADprcD2sex0ZWdfIBDX25mQrJYgKkPQcNivAXFYEEFIFdgRvJJw33OKTXJzRuZcuy+Z0LToH42UbfyltHdri2RdQyrmarXkfRRM+DsYaVs0YWhEIzYUHN/XKWxFe/7REpBzyTgVl2Qs1UYOUs4xnTD+ktILMCDbjgriIrHIkVTCAUxDlJaby48jkg7y8XYosayiygJm6EyGnjb61HbOIEzK0nvYTEYwj4t5bmZQUj3g4wOHrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.
This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..87796b617d9e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0


