Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DBDC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE9F6B00AB; Fri, 21 Aug 2026 14:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8208B6B00AC; Fri, 21 Aug 2026 14:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7365D6B00AD; Fri, 21 Aug 2026 14:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D04D6B00AB
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B56EF160221
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:13 +0000 (UTC)
X-FDA: 85126186866.30.5F37C43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8132E120007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VdFmHHaF;
	spf=pass (imf29.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338691;
	b=A1Nw4hZ7TbykBZ95a6K87EeBZ+8WjLGWbTwidYaa1o8pet+bhpZHTaZv232JEvmzt/USie
	tfhncHgdKiGJL7HYKeXmpZDSxk3zYnXAgSiSzSNY8/ZALb7SwZU8LM+nJdSNCL9Er8MgvC
	hgLhAlp7jmiGUxNE8j701cikW00u9rk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VdFmHHaF;
	spf=pass (imf29.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
	b=HZ1wbwOtIkCCIVp3O1XmeyPmEz51GSB5aOS9r/5bw5CLdIjEdafqZPrALth5OpBZBI/0a3
	+GwW05r+8a2XQ7BfiHjLGlNBj4QQ/WnDdJurCFHGvgI+g0zjo5xkEW1VimK/b2Mca9Ltu7
	WyxrFfzszpFbmngXrABCCdjrpPs0pbs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
	b=VdFmHHaFVSwTKKdVDKgzAHkC3I9AkzokWLGL0qDOxe7tZ0oXQuaJPEiFM8doJcb7Sz1h4A
	LSvY1nccYrKwnAqDFx7320Lljw5B0/CT/t8QtoVebLVkgSLgm+XXEp/9dzgIGzEHGnysWX
	EJntzN31fIAVBi1WU6uA6lJc0DJZBd4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-ES8vpbz9NliNEmoznnHQaw-1; Fri, 21 Aug 2026 14:58:07 -0400
X-MC-Unique: ES8vpbz9NliNEmoznnHQaw-1
X-Mimecast-MFC-AGG-ID: ES8vpbz9NliNEmoznnHQaw_1787338687
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51bf321d786so12354611cf.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338687; x=1787943487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/jSTYPb5+iqfnKrVpM0EYbQbnYNP4KDzbEmhzVmVac=;
        b=CIVueDYqAnJ4MReEdMy71PstWdkhQkYyJVEUUX041jjPmjw42O5ZbI4ngD7flsD3q+
         KQOIcpbMDDERv/aB6QJSpLbVWWFx1P/yjd6Dq3PgXJUN8EuahCVE9zPF0/UKCLT0WnMA
         tlqJDpR1y4TjPwmfgD4m/l1GpuYoRpyffhb0UMG1xQlzWCTalt9OgHHjcPAHc2LWjqlm
         p05KlqefHepuzfV8Qkhrq+cUG02aCqgYroOC76O2zZMuyV9SIkvRSz0zGyxtTnHrmNKc
         liVzrFHSTcVG2O1RCjkyQJsWFGPW5KJzy4UEsz6mfz+nVibAn5e/Kiou0bBD1Es20Cvt
         xAWg==
X-Gm-Message-State: AFuF++l4A9+Fj0Nbf44fWmRKsZbhw9FYLi9Rwbz/ukWFFApPm9Wnw0yK
	4Vx2sncf1wEYEKzCS44pLAhGd+0nukfNFhJs4Nq4aI8Q03AbijH3PSpRPX6AN7bIBtWgrDDg2kj
	G1nmkDLRVeZUKTHkoCTBCPfe7GHe9DM3nBvUe60LOVJY+Y0Juu8Js
X-Gm-Gg: AR+sD13ZaUwZb7KPF31IMBcPoVadfcNp+fqqJWJfaaqO/XJMmgiCkF8eT5xrwljaXjU
	5dYlsm/j/ICVYptrDJzI361EaCUgj1XQ+XmFDnc0s4eUMZFmWlE0mnlAcmzf1wV8Sg/tfdEjmld
	B2vouzA/KaItMBZtImJHHOUSf7Zps4CWObsUygXAy6djaftIIqAGZy8mdZj4wzGfx+ScPksf58h
	/H8kRMEm1WawUr5HyMdUYVGf8RHivkzGs+ujeZve1OwUZI6oCz8O67YpfH12JLXsfEGmYq1y18x
	MbwVICXzk4r6btiKYBOVaneMLljCLDLgPMgKTFsUbW9p0zxRHeh37EZQhYmBd2du+NE6jHAZaws
	ueKb+/v1mTT3d1iaL1U0jkb8pEZlBI4KrJqjnakdao7IU
X-Received: by 2002:a05:622a:1353:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-52df5a08383mr81012181cf.25.1787338687116;
        Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
X-Received: by 2002:a05:622a:1353:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-52df5a08383mr81011751cf.25.1787338686645;
        Fri, 21 Aug 2026 11:58:06 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e099a8331sm1163531cf.9.2026.08.21.11.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:05 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:59 -0400
Subject: [PATCH 07/11] selftests: cgroup: add cma configs for cgroup
 selftest suite
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-7-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pBV2e9pMMl2V3FDNRjCixDH1VyXHuIJrVhgb19cmt1M_1787338687
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8132E120007
X-Rspam-User: 
X-Stat-Signature: 3gbxbz9bp88gg6sum3pjqtfnihw849rf
X-Rspamd-Server: rspam06
X-HE-Tag: 1787338691-168071
X-HE-Meta: U2FsdGVkX1+p63eNeiiiUIbvl3cX3KKVrTc5nZx5mfnSUuPMAUidXtSxm56WL1LIwXaRTUitiLYmlMvK7yX7ec59U0iON25svL2ZhlY/fc3/lVEkN9Pjxscrmh85BQRtieDt1glbi3crldZve8kDwOciR9NxB+KwyfeCJBbCr7S/UzARh3C3SHfENyX5yciXBGOFt37fASS0Vuw8EUVfoT4G0KmrdRLEj5/dDyhbRHbCmXgT/oHKsatfz/fcNNiRG9lmvAflDP+jOb9S6eNvZWEw/+eaasJaeMN/Kk3RjgmVA7vE2WdS2YTgTc1M5Z7xtj5mpJL1xMUqPgqsEnyT5Hd76HnM7u3Uz69k1wU+/1nnsMuytkmwP1C4w9lIjhV2UswLhTPbyRDcfkDVnUImW7V+xTmlfFjcDbgSXF2HTWRIRzF976QWAcKBILmgE/Nh85gva32j8KvWqDi7q9MN6EgiKoNwrFbgUaZm95akCk7myTSF2G5biVEenLQ7u/e4Yk4EgkWR5b/cfcIKf+x3C4zCmBeSVmggSGdjJU+2UK6BLcQebmjiPfQCA8BSU50useny+BaPT8BeWuxi7Bw4ajVtz0bUhCJmHhgEpJphf2N5NMpbB6hYDaEzObwj4cU/tm8eMXmKPnDaKfUlCKdcjNrqdx3nl21KcHmIvDQSNYuyFHzvY9ods+If70NGU+XDtKLROX6//W8e+9HuCDbOErnLgIoXJDr4URYJxbXt59lffIlkSTKTYAx2Y8lzFcmUBhZAVELDIJ0Rv3RGiWY2RU8OeFGh86OYw+wdmNzkP5ffFDmhbfkh5PsfceMLn1wL1ryIwahrxHCJAyzZrvVyBew5jVL53eZfmD6hYcQpRjWZQxdrB6OcteM3HrRLK4Zg0o3VDduNzII6/nvuRntJ4i8p6T4DDRmpkAhIB+VRAOYbU4cXpu8WShHleSzVmSvO0K8meMdMgPb0qd2UZIE
 1pBM7wk/
 5PXb+cXQ5c6HA/45SV+te8YTS3YLkHnVZn2J9/9tVQazLL6tK8vPbBzplP3k8st7sP3gkaJaAjJAMmLnZFjRgXMC8MMUM9S6bx9cKX3hI+eZ8pfWwX/ntu7jbchOGaIqATBis3VMmZD/LA86FsLY4u2HI3p+93ov0dlqaZtGrj5yUelEq4W65O3mkQ6W/1+BGUpmjH/lLX7hI/jRJ1xOZn42wfE7Iap6rLX9U4lYW4kmNBnrqTcxteYQAtTmF0OYDbJYnOJwNTgmXDMP2xCerKiGowZVSQG6U9KndV3T0pHGWZbVBjdXuSwRj4ew7pZweALaIYJVKp9oGF3/lbOf+mfhxNh9PClQwzxgfwsBMRcypB9a7ksY4PBWeGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable CMA and the dma-buf CMA heap. The CMA memcg tests will use the
dma-buf heap to allocate in the CMA and exercise the charge/uncharge
accounting.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/config | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..c4f7df4f1b24 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_CMA=y
+CONFIG_DMA_CMA=y
+CONFIG_DMABUF_HEAPS=y
+CONFIG_DMABUF_HEAPS_CMA=y

-- 
2.53.0


