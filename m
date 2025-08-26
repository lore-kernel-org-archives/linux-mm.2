Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1ADCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E238E00B5; Tue, 26 Aug 2025 03:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EF08E00A8; Tue, 26 Aug 2025 03:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E4F8E00B5; Tue, 26 Aug 2025 03:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFC68E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:22:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD32A1DE215
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:22:03 +0000 (UTC)
X-FDA: 83818064526.13.3F6C142
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB0E2120008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:22:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MAEIx8KP;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wbac2bbB4Agf6ejMhEQ8dWLbxrMb1NMiLXWF/bBnvXI=;
	b=Hd4CnFx1rjgMsVMo0wgxn3MDO6FXtXTroAcc3GYlxXI/NJLWsMJZ9cJdQj/g4kMYQgFXnH
	l9U794mArKmJzfGn4xhlSo7HvDLOSrihIRmZxsAL+1Tj0TooFioxug/GT6+CPIsChKeQBF
	MnL90W9hjGYMYAIdv6zYX/GlbVHpIcY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MAEIx8KP;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192922; a=rsa-sha256;
	cv=none;
	b=sK/Ujw4BU04p61AmG57W85J/ElLxPbhLgVzUG3R9MFUeCJwRadeCZ+hM/OVdNSakuqNrJN
	MsNZNK+gtzSb4NqbGR2x7zXGnk1x3TPj1PF4yVjahYiz0jhWITi6TBe9Z5MCqwrF1EMnP+
	DUg6dkJm8al+qXdJNEYVngrLauoWoQQ=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-771f3f89952so659160b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192921; x=1756797721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wbac2bbB4Agf6ejMhEQ8dWLbxrMb1NMiLXWF/bBnvXI=;
        b=MAEIx8KPTU7iFKePqtxThR+ydK4/u1V3J8oLr1vQLJMW49Q+6Q9M/GDI4d1vPGZzqB
         0HdtzvJvJc8Mh77/6i9qINoHgO0dFhG8O847jm4h6CLWq3gC1zsOdK9cfGZi4ydu9wO6
         IzuHT06mpQtg9KoO/C4HP2ZlElT3NWs4aZztA9YBeDBv/+c7/l+YJWGl2HTbyKM0JSa/
         9xojk8ajBSPyjMLFqg5oftbtGSjFPonmh6Ojs8S0DhSPI4+ArJbkzBvi9iSf9LeAV80k
         a/7N7sXU7LJ5Ud4F4gmsC3gbHQBldr9iJa6srx+uRABnoUqSWFx5GwkEDuGzgHfIC9mQ
         Unfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192921; x=1756797721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wbac2bbB4Agf6ejMhEQ8dWLbxrMb1NMiLXWF/bBnvXI=;
        b=ALPh2EyskHbmBMB8966imMJnwGOVxHRpm19gpRKVQQXAHHbC5+4f5ez6oXp29nibik
         IZi87MVJrFCi3jYwQogRmXSmRsFeoAvHZFP3mEhBnSD2XDSSSpG52iw43SF6qkaKNEKI
         XignXRO6FfZ2ehtVRjYXo5vK4mmAwRUQNjgX1i9pUY5pDa6/QI0zVk5P4uq+wOcsgy3R
         W+SulMVXb+n4BH4P9MJg09Wr2wne30jkVPUTEhxyYu7nAv1nIIyIhIkMF84Nf1waoPNl
         LvDSOuUqkwsjfmaRuX5ZfFBaVVxxRNkCA6RU9e9C4dfrugpD8CV6iMMYLXuCmxwxW/o0
         AgrA==
X-Forwarded-Encrypted: i=1; AJvYcCWZdCXdFXOMs4on0zDrjw93D05i6GK9Wq2IK/0+zc8xZ9JNbboIQtvMAQA1OvX1pO0tX2Zb7rY/XQ==@kvack.org
X-Gm-Message-State: AOJu0YwZjU3aXJzFUCikV3JPxREpui2OcxuxDzce9PzqXDah6sior0le
	PSAvQl/EtAFAkaCWLsY+OqKFyqAI8AbuvdS+B+3bGe0GapNtx6b+Bwnf
X-Gm-Gg: ASbGnctH0hUIWW4yiJZurlneaFKcs06OOqo0sT9aM5z4nzvvzfraAau8meSoiIxPhSg
	I5vPNSIIVYjQzuxqejREh3NZxDhqXsIjdaPglfnIxo4DVUVtGDhzYUY+TD6MLn2bpUXcBHVzi4v
	5a5yM9JIt9rvb+t3N2HnhOEM6B6/Y8HFAB8qp4HxAZvyMEMHVPNYodWuzBSccIxo3yM77XMXRyo
	f1a3k2jbX0VZU8t1CsGm3F0/ZHEG3CCjSw3Q6gx+sjfcn8upZFiOW0pTuqoJ71wYDg9v12fs9m8
	75rDpZE7dcJCqpe0pL264KqC1wesJSEveU4rBVXzhVgwXn0jxOUw9IwmBN+HE4xtLxc+LbkG9I5
	8hi3d7apNQkN51zVgrkcS766S7MtOxTicHiLnsteAW3JBsosG2aQEJ18/fsVFrqypMa31SKUtVu
	d7nVtuMu7OFsd77Q==
X-Google-Smtp-Source: AGHT+IHDKkxVACQPZ2nUxU4qBHmNtw5UPdoF1DrAv6TDPleHClAcC9RQjauPOEwrVtJF+n2mv+hsyg==
X-Received: by 2002:a05:6a00:3d47:b0:76e:99fc:db91 with SMTP id d2e1a72fcca58-771fc292f2dmr715991b3a.3.1756192920839;
        Tue, 26 Aug 2025 00:22:00 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.21.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:22:00 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 10/10] MAINTAINERS: add entry for BPF-based THP adjustment
Date: Tue, 26 Aug 2025 15:19:48 +0800
Message-Id: <20250826071948.2618-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB0E2120008
X-Rspam-User: 
X-Stat-Signature: 9z7ssdm4w6xifyxe1w1airnnf5ub6u7a
X-Rspamd-Server: rspam09
X-HE-Tag: 1756192921-804491
X-HE-Meta: U2FsdGVkX18CuCEADPPwTe2z8SKIwah787+X+76KPLlppuE7qszDVJXvawQoMkliY7IZrtg4DM3lRRdTTBLe6DZSrIAyeo1YgyaCEi3TR6TB9Nc6ewZZNPmB1qQjc1dRByDL/x328RgVAJiiqmgtq4/MGEEv3rN4yT3s+5PD2uzdhrgb64hyKSxVbYjotsmEL09gAE9TNG1PP3TIaDkLpjuo7v9hVa62fq0SZQWnaG/gpFMr+OwuI8TPcFINWM8f1ksXzjrWpDCiLduT5VMmp/J2VXTYPg4kU5JLjBclhPrtAH+03h5RgdQy8vF2FSLnIoY2i624e9CGMe46C8ueGiHHwSc3AxrzhovmOdlemcfwmRRsc25+W280D7ZpZzG1PfU9gkdYcvD5sA2pUGDEG3x2TdKcmyc4/4ozPs6EfMGrfAAzvvoRUFHO6QN6X5yAbARVUxfYpbVRUYfvbaGr8OOhwPTzh5EJFP64WnOkxQ36O/A2XDGT0mXksW7yBwLzJM8PlPwGL+w9YLpEZd+iiVrz2muxl+Ft8vixuZUp7S+h0CTyWovT+gtVHYWzIHU1U7xM8WKdsvnEMCvuqWDoYfzspdnLfyfhnBZtG23Q3D09daOs365saYHAv9iF9ijPBVGZHcZv+jO3EBLsVK0RUHmEurhlAgoLHKR0XF09x35xkQfRPMY+TFZuFw/hrm408gix10orcdSJa1OHnjA4uFXd5RjhG2uSL/+B4iQTHzUouJWjbob8Ilq22xktayxBkdxbr2S3HoILXNJ8uB2DkiftcdIqkjnd0p/q8cusEmnKxjBTOPQtqcvIEGNGsQe+plm/aaJExkzL8MsxqNQtCFSSbp+TXi85D3aMfmVmTeoqR2DDEeRPlYyxL9Kyb7T4i8iUBCzQrlbC7aFT16ekDK/UfTEIYM5O37q89qokJF/MQhx+EIozBnm4O5F+wSOd+BrrToFQ5lW1ZmCseqS
 JfC9thaK
 QlrVu8l4++niAL5h5mRjEId9EBp4I1G2BImzGQXh7uSo7tMtce3LN4zSa/tYl4AhdL800Gz4LU87K7eWJq5YtxICINAQrsGnXkIIChKSPwlYeVTxNTlOEkLK9W+zjOzPG1M7QfnXK/bwHRPkFU/WpJzCznhTnowgVZA6pg/jcuTGgwH5sCpDvHOAOL3zgIFriEh/9/Pi1h9yJHQzAdWhrPB4m4yqrsYqu870Sc6fnO0PJcpzSecg3EHxNUub5ACQxml3cxaT1gAZo6MuTfNDibYgWCJ1liSPiqoR2QSEYFmVA5WTxY0TLQIaKHwQxLvkTOI8BQl3JsF8r0Vbf1REMg65yUKaimzaVBQNR7lNbcIRZykUFWuKK63RFBgLY9enttE1iJGT2FXhBjpjKGfPzhCJqU+CF6Iso0hPK+Tp15C0f08g0kkMHCdAwe1Ye2JKIpN1JD8SllA92yI301FRHUzpTpV1DpHsIl2cB84n1hmFgtqGGTwauORrNvNaF6jTDzoV0ACZUiF7OzvEmvX0ocoe6ZY2EtwRroj2VcU8xQ1qgOoNJhbjO02tTDRSqnbaQFwhiBjH1fmHjd/HDU4fjexa2ymdsh1hDxLiyNy6HJSJznTTRx2tYiWow+s25W5NGPpc5XIKu0dwbSvBhwXDv8J1J6+nDsEOkY4BgkH50sM3GmhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add maintainership entry for the experimental BPF-driven THP adjustment
feature. This experimental component may be removed in future releases.
I will help with maintenance tasks for this feature during its development
lifecycle.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 390829ae9803..71d0f7c58ce8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16239,6 +16239,7 @@ F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	mm/bpf_thp.c
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
@@ -16246,6 +16247,15 @@ F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
 
+MEMORY MANAGEMENT - THP WITH BPF SUPPORT
+M:	Yafang Shao <laoar.shao@gmail.com>
+L:	bpf@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/bpf_thp.c
+F:	tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+F:	tools/testing/selftests/bpf/progs/test_thp_adjust*
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
-- 
2.47.3


