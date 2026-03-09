Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2C2EFCD78
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCC86B008C; Mon,  9 Mar 2026 05:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F409F6B0092; Mon,  9 Mar 2026 05:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB766B0093; Mon,  9 Mar 2026 05:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C16676B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:54:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C29E5B07F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:18 +0000 (UTC)
X-FDA: 84526064196.22.216AB91
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A026100007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nFVwWfm/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3x5iuaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3x5iuaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773050056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgiSP3km688q6ojjEduHXzfYAonyqsNdhLOg8lFMsCA=;
	b=LSQMgdbTdUSbMH2KuvBdAFCbKj+34WYAcg+zy4xxk0GY5wdLrHvBQIeGEiSu2u7oXggcpd
	5slsUrNq71hY7tpXANkboE7CkPoKmHslemvh6LKIsBsS0hqkB78u38PhzK2wrEj/UNGqaA
	XsxHPBjCtQ7ZR6LshBXcEqLcmLO5BEo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nFVwWfm/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3x5iuaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3x5iuaQsKCAgiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773050056; a=rsa-sha256;
	cv=none;
	b=6kKBJyfpcfWPCHZs4Sp8TLfsr4cq6g1XdrbHWdgncRSN6gZgN5qLuOIcs0laWw5HrddDmP
	EBvybpR+Cw7Vf9oZ4LL4H+3UDCv71lmVUtTB3q1xdUVveXPWW7zYB09kYNjnLNWUdbbpi8
	C2q7FVq8duiRI43peaqDJUZnXxwyqyc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae59e057f1so85643245ad.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 02:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050055; x=1773654855; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QgiSP3km688q6ojjEduHXzfYAonyqsNdhLOg8lFMsCA=;
        b=nFVwWfm/LzPLzWhMEpc999oSCwETZ3qIJ4RGqx80Eqd2b922VVSR4IXnhbnt6QJ/w5
         KOs2sAN2TkmS69jKWLeo4HiK7z+BeUWSXRWuLDN8nXJn3iE73mdWEzG23sND3m883hqs
         wyncb0AIDn+FT5q8hp1x7JVQNV6J+KVywYdXMcA5vbEwjZum5eeFKvX/GWvhPAwquHRa
         DOENF7ElgOHXXWp9B5RWU6rG7IYUGtlhtguSjXAZ9NFHyZAnk54q+eA/a/fUpYIhTiwJ
         7/uTOmdbTOoctYUAiDHTapcJZp20xvwkdvvMt9N+n48zYfWAqp6x9ey+WqPDUsgYlYFw
         YkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050055; x=1773654855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgiSP3km688q6ojjEduHXzfYAonyqsNdhLOg8lFMsCA=;
        b=kaT9b9iqoaY+7shSTEgHI1Izho8weKUciTDl2S2zVwu9Q8YUYgz15aofjj2KHz1Tl4
         GqRVarGJA7dizCqVKPisbweyE9rTaTprkOqSp4XYdr9EBcaMbMCaMwSG+MJUJKJ1AdCo
         CTkcuy+lRbQfe4l3yCPCCeps+8ckVYrNT57skBI50N/kXRkZD8bySXfiS9yo5QE/rwKb
         jDABqEv0ddMBKQVItHwZLXo0cAsSBNAO0iLiT+tyzxhG5UoIPsVUorXGuvTMQ/i9KM9q
         oepbLb5GXJnizPwikD1SAVktc+fvR5399bPt4oXC88qwO7tDi7jd5ceCle1+fIhks59k
         ZfpQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/gYHv4N6b6OluaBUFHYRP97MvP4vaVri6qKqWJO8t7g4AwRMgMgKpEr3lYRIfe5wLcVsxn8M0AQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6CWPxiCzMMK0wBLmILcQ7CauvJzfDG1a+crd38wA5jci46TKv
	O5JmtDJqSn74moQPuX3OD9w+jxbnAYCqpTmwp5e3QUO8jiqc4bQ0zKjABANKgTMRRdajvZH0IWE
	kqrFMmh3fNycIiS/E9c58AKSyxw==
X-Received: from plef1.prod.google.com ([2002:a17:902:f381:b0:2a5:9a43:6fdf])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:18b:b0:2ae:7fa3:df1c with SMTP id d9443c01a7336-2ae823985a0mr98528365ad.21.1773050055283;
 Mon, 09 Mar 2026 02:54:15 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:53 +0000
In-Reply-To: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=820;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0dslHDfc8e0m/ec8VD6G1x697Vl+o1F8eHqZCQrHxw8=; b=eOCypP2XtIK7WY3YqZd54ElrueSK8F6DJhK/7Y2HZaR12KKA6z53pp3vMBE5jxXzUPXRiI7/S
 mHsrhIlZsLlCMKxkujWBCQjp/ZE0AdpD8N7mP1eC2QkmTI2K/92Y0+b
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
Subject: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A026100007
X-Stat-Signature: zyog9eoki851ftsq8rskno9n8pee69au
X-Rspam-User: 
X-HE-Tag: 1773050056-769623
X-HE-Meta: U2FsdGVkX1/gXJtLzNk4ybtMZ45bi8u5cBULuhPUMhfQtJvSaVcGxUSoWAaThN9zaND0tzMSIPSWZKacn8KYwmQdmOlaGYixLzauSyO+OihCqwQIE3Pde1rg9iCUy4+fx/i9Veic1f9X55bqBV9mn53Q7JKVf/pSGSvsLgq1jvqxNi5P+GTTPj7MDwBPZYwpRRyNLEuHRNACBt3tT5S5zeyOcoXUDkgcmYC0WmON0k761DnEi40acFgy4VXEucCj++6D3e0RuPQk5+vUfxSLxyUti+4lVv5bt34wtYJrAVcCo8YuSBqR8+1N68e9gi2hh8EUYmI0c+CWIqmfhmyVX5WNysaoFE4Y1S7i2vYV/AqfTW7WrgEpDMAJ1rKFvezT92JDe/dJhN/jUZU/0mCG1YUzE/mvHYBvPVDNnRXloZssvEYfowefqLBzVGPTK8RiIh9BoM8d/E8pocuhucW6GycUSMVV10nDX0brl+wIEBKBgTHtwIPCoiZSJ+tDQ4ki6RNG4jJp6ZFbBGoAXil6SrpZwOMb2j4UuiO7t/iotKeTbCbO0DJy7k9FMWiZSTd4JC9UUMBnDKmdVyGe72cu/SQnHOSCs6XJtH4mF4bMEQKp3sKj3x0nVGa3o6M/NdwH6byXofD4HMYurF0bTctlXK6dpw+jy5kM3ZAawz4eOXZkvaw45PGruRERL49EgdbUGBAkqIE6+KNAEplPGdX48ZQiiMcnqNb7nBMHrScW+ikHZ1coB++pEWoMNbs9MR4+tOgUpUn99jipUBLg/Wg1tHTsW2H70Fms84gpYg9nhdapNPL+ggAYv6tu2OxifnxfYGDGpB2muxWOi9s8o1afay+It75v9/BGTXnV/pjKp0TS6hHE/53y6DXQ9KbN9FIrY1B7PdMya9CvHHv+foanI9AmugdP4OdWHKOxtH60Ma7bp15MuATiOOWUOfDzQkm4+fOJvrG+RKakOL6NkfC
 c7Kxljda
 NzJ3Nd3o00LF8yML8L9ansmt7EdAaAH2gA+4IIlBU8YNe6nJpUniysOILjpG/DIew1qU/zkpbByaLewJCK8831AAd19yfgpPomdGvZQTpPWuUtpUNCRxRgHkNbOBO3eO8hSUIOzeRtf2fEXc7oLO9rcwKldLVpfa3yNT0e89vdDvTNE4UvX91se3H2ketvAZyovPrwWRl9j59oWwj5ub7L7PLOD/MizCkNj0Tp0SEBO9j0Yxu+FH9RQmwS6R6dHkE28beD3JT7yfcMOLs5ZanUCvBy1dZMywK0Yi473ihpdjvRcD6RiUrogfj6lMj926icR6qWiRblwk+CCAitiPrGZNo8d7pHnnNzgRroSAeytI6PYENuhLtkMjrhNClBKJ9HOhYKlvwKGS0e0Zpls5e8M5IC1MU2hP+Tlw3ynF+WPsL3Pzp+9Vylzjc4UwI2FCPaXYNUIL4OsNCvJMQA8uAOUMfHErj0t8jTwWzut9IdA9azOmbv5Hriyh4YCY4/kVekhVeDK/LmpD4P7t9DfDSZSqkDKcCsRyBWL7hs7h3IJUzNWPIinNebqaubrahh8VZjh4e+KngKgx4rXbLr7cUDM0SQKrvHtDedfq3Eh+KIi3MIhA/S0FNNK+N+QTvpYGRLdGPs8Zl5N17X0QWWSsfQppHNmnXXHeWfthb9rQWSpXV8H/b5KUKR0mHcNBa2ViCI4d/oSiZm0tfq0eVN9PF7VmXDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set release always on guest_memfd mappings to enable the use of
.invalidate_folio, which performs inode accounting for guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 77219551056a7..8246b9fbcf832 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -607,6 +607,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	mapping_set_inaccessible(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	mapping_set_release_always(inode->i_mapping);
 
 	GMEM_I(inode)->flags = flags;
 

-- 
2.53.0.473.g4a7958ca14-goog


