Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7101CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED26B6B00BE; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA6A6B00BD; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFAFF6B00C0; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B57326B00BD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23538C0512
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:41 +0000 (UTC)
X-FDA: 84127781682.16.878E0F5
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 267DC40011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OYW73sbD;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slnZKLktel7FGULom0AhklQ/3aJdt8tuo66g65NOCPI=;
	b=XKKgwgV5bkBm/WwNq7/S2coVksp7MWAfZMs3hydb8QU8kzkf+jOTtvlAE2eFH+uPIbRZ4Q
	ovJ0ZIqSxjjCfiddj2wvuxMwmHKsPku2gDeMGz5AW+7YO4IwNBLUQo6gpCxVUt029+s8qL
	8SRXyQPXXc2bZa5UDzpSZe4szATrCa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567139; a=rsa-sha256;
	cv=none;
	b=Tcbh8Xp2ZML/Q6MFYNt/lOeG0eWnYmp8Gutyzg6Rz0prtPbwr5lZsTA8snSvcAbHHZVK7Z
	sk8h1w3HuQ0YINMTbMO3OQgbXTpcH9v3QgwpgpvTQ3JlhR7RWSpRQF3JhDKevXjzZ2T3ET
	aCqj+j33SDOg9FRMIIGY6oqFdsGKDHo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OYW73sbD;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b3ac40ae4so4186904f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567138; x=1764171938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slnZKLktel7FGULom0AhklQ/3aJdt8tuo66g65NOCPI=;
        b=OYW73sbDuTj1s9QHN6mqg35KTkTgbuRijyFpFlysyvttu8acW4g/I/ykB6EM2rPAqO
         F8D+E0XIV2OdW0+Tyz5DwdDyi5fgLb/2inPcyY9Cbxb5rjyRvahNuvdahWahhdDbt8nO
         F7RYd3T7X484NoQd5OfuMj7OZab9GCQw7ttZfKbYt28N59xGHPlkaD7LtywkyIsV7BIQ
         3fwN5msH8jkYJYREzZSytUI10OWkYGTj+Rpg85+oWWHwFyOCyHBJjnIqMkF2nET/X0ZZ
         LvOdei+RPVi4KGiUb/LyHIiOzubmsY/UhX1rmbwRcuRgWjEayJv3mvZSiS9X47B02N3j
         RKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567138; x=1764171938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=slnZKLktel7FGULom0AhklQ/3aJdt8tuo66g65NOCPI=;
        b=KOGhTIWZ7yd/KTFgYG9Ka4/sLrhryTKfujpb5I+NXICZnC5Yb5qzJdJFe2vr73pXiW
         +1sjpJ1wqhDEpQgzF8TGw3jBuApHruKam1Sk+IWx+/+UUbefNXxT652BpHvHfTASh+On
         DBQK8626BhyRV6642L8pUyjc71oLACWgjdvZ4C+NKEIIUScWsdaQ3mD8N98qc793UQ9s
         PvoVrEGLoKbhorRkqKveoa1S384JrKdcUCYMtiLAuiIWTM1q+7/4v1XU9WX4t1cxZ7Qw
         RjqGmvVpueIIa6oVeNF91RzsjABjcDqU3AiJOlgX9WcuZKxPFTc5OkHj/pK/J80aQsxf
         S4TQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0/gss7d/MR/SpuFUlpewQBVwUFrZVTv30oJVBsCjoHahlaPUZCBL0GJoqXJgatS8hJUdT3H9+og==@kvack.org
X-Gm-Message-State: AOJu0YzKi+bnoln+xcJap8yDSBvJCaWyVpYjtZcBEzLFMYs9zlC4Q05q
	9bJbTwhZwDoJiVpruMmWnlFCBinfJ3pCUYInoQIpwptRgpKzSnMBXf/KUZTIvP8TC50=
X-Gm-Gg: ASbGncuFdUHGwpK4Bhq2JD0WgWrcyvovSMoK+g3DyZ0ysZVrEibH8nivstEp8I4J+iu
	gAS+Af+27Txu+xxRAY+u6L8vBMqpWDZilWZD8AQrT1Rlzu19VEghfWXNu/w1pybm+tyqplyL1R8
	kdgkf/KAbDbo+VFIbL1QWnGJCGEeSHmpyrTIyPIFYHhXI9r2Ew9RvA3flK/9c3FCZXqlGG1Bgaz
	0kHjUzb/2hCtjCaM7XTWMpj2hT+PolgMJn6LQBhmY2J8LB0ki6S6iEr6oH1pAQd489FJpWwfkoe
	H4q2OV8Cnu5EO8xlUaFydYi/GRyYmMI4CEkEiAyWL02lHiq6XM7x48FlsEmp6CnXUvewjKhJ7n0
	T0DzQn9pXip31Giv2DYxkDB2//PolsZpWFkku5JoCPgMvEnA7wMXg4jXWkzNyAHSOZikv6M5E8k
	ldk5k7tWxeBYJ2J7atIfXRRJOfj8cNq0lHUHsKKQpn
X-Google-Smtp-Source: AGHT+IH9XA5XKwB+eYd4P52AVjjtUkCjRx7TcK6UtIfvF/aP3IOPVELnIO3YhYk8yezAw62YpuQ83g==
X-Received: by 2002:a5d:64e7:0:b0:42b:47da:c313 with SMTP id ffacd0b85a97d-42b593395a0mr22250899f8f.3.1763567137600;
        Wed, 19 Nov 2025 07:45:37 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:37 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 12/26] kernel/configs: Register dynamic information into meminspect
Date: Wed, 19 Nov 2025 17:44:13 +0200
Message-ID: <20251119154427.1033475-13-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 267DC40011
X-Stat-Signature: yewc9bo8y1i5nyfx6okw7d1314ghcktc
X-HE-Tag: 1763567138-391999
X-HE-Meta: U2FsdGVkX1+Qgs9EHq/LdkWyA1d0u9oJzBwl1DXBLGqJZ82vR+l2C82jVst9klYhQ3qn+oQHJG+DwExmAw/mFSpv/lwGn6l96lOO7UpqutZ1k3gwciR3jeopujRnJQ0IvVxQXTJSBPNwtFjWR3NIzhsIkS0+iTBFwboxrnR75z/Zzb1ki+R7FLqokSOE2Nw8IKD9+YerajIvOuLqgykFkPN86aW2l6zkwtX6uWu2/azszwY5pBi/GCXYJOTCLNSi7u8E43BVUitbayp6qp+8tz3M+fYLHrEiIkTKPQNoRleHt1/MUVcpJpVXN5eick+l/Vp55VGENr7Yp+WbiusrD++k86/Bpuljfogm+NQsDSV+NQdJSj/OR4Z7Q289A5ApBKBgvdc0g/506DLFxqP6Rh+OmMeYmg9MoztbjJxdHVCP6ZiCpHCzyxv43Be6DQOYhDj78aWTuTbd3phZEYytu1SBZ0RsRQffdX/uwBQ7R261ZCz2UOkYfTQcqKwrkTLVNXuyhDILV5i2A5Qke22Co1BzFKI4nKzkimdUTiqfugDckF9Galur/1JIJ+qlx9nH7T687lKZV/DCb8Gm2f3jsJ0llG9Uv7jfe0HficyNxTfLvOiPzhlLQCsHzEZKjvKIhWcbY1t9od3+HXU+PHD5wlEx4b1LjI9NaGN08NE3eS6SCyidw76rMsjapf24Mv8Uyfpn5AfVVNVbUvVm8afR7nUMS/tZNdiYQys3GoYNB8IOloy3TzuaGcMqN5HD61ADqfqtxdDY1gA+gi5pc4p6f4g+dgBtczT2w5zwNF7ruzrgcx9KtTO0v3LRNm0JugV5F0gv0BV5D7FQ3Fex+MgADXjVWrzo2Dkn5dfH2g30XFsDyDEz/YrEOBOADIpfJKAWQRFbs9lXjSVPrJPyYfsQB+0Cp6LD3larj11f528jtzNd6Hu8gmR6dJ2BStxgjN1wwMZF7ZTWWsjSn6WZDTe
 48J//IFa
 XKQF+jd4okx8S7U21oGOlBUrN0OBcUnmXHfYrujBE9B/38c+Jod7+/6HxrwL/O8Lhm3IPKnj0GqlYLpg45F2CyGQSz4/MHNgivbZkkirykl9P2fHwS+vrmFokfEq3xZfumLnoIu1J+0Cd1IBd5K/FCHfSGWj6SA/ZOiCensue8Xcis/uqEtN/HQRuN0vIUeumvtwDMmvm/wfzteqkPF8cMomN++B7o1p6Pbq+LiiJe4Ut+PEAauDtDdsaInINMHTFQVzgbLmD49hMFJ9upi0u0cqM6r/5r8RT9CoHYf7vf5uHE/QE+H5nNNfjmnwvjNlJWHy7j7t2SJAohpRGhB8yMlO6yuJkbTRlnmpWfiMUgwrUHz5LOMyQz7v7RlP9QMeurYblYiLJpBc5XLf8EXa55cCfdapV1/ajzlp/faxABLQOw1syYCgxXMgEE1yaq6Li7ZanaOJp6hbFI4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register kernel_config_data information into inspection table.
Debugging tools look for the start and end markers, so we need to capture
those as well into the region.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/configs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/configs.c b/kernel/configs.c
index a28c79c5f713..139ecc74bcee 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/meminspect.h>
 
 /*
  * "IKCFG_ST" and "IKCFG_ED" are used to extract the config data from
@@ -64,6 +65,11 @@ static int __init ikconfig_init(void)
 
 	proc_set_size(entry, &kernel_config_data_end - &kernel_config_data);
 
+	/* Register 8 bytes before and after, to catch the marker too */
+	meminspect_lock_register_id_va(MEMINSPECT_ID_CONFIG,
+			     (void *)&kernel_config_data - 8,
+			     &kernel_config_data_end - &kernel_config_data + 16);
+
 	return 0;
 }
 
-- 
2.43.0


