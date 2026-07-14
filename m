Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97322C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1436B008C; Tue, 14 Jul 2026 18:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8FC6B0092; Tue, 14 Jul 2026 18:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7866B0093; Tue, 14 Jul 2026 18:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7636B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C03F74054B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:33 +0000 (UTC)
X-FDA: 84988804866.17.00BFD55
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id E04E8C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qWrNd4in;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
	b=iXhPn7NO0OuW2zoDOSrkCMqxkhXRJ3EUzK+ndywUK5ndH2RIL1pzfC6oMiHQM5y0ioIOBi
	d2izZ9vDsZ4Ho7z/nOS9zb5ZNNsT1KpEIC46MnSmG8awEUuKShySpe3C2Tap31kbxIFmlZ
	9LO0uKpxEgrmfKpLSUTkGIQCskX+z+M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qWrNd4in;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067691;
	b=OQR96eMLf6KuAzRWC7pgoDWczdkfqU9Bcnh0tnqJa+6oIaQG5ztbf4YL4+URcPRC0ob+fc
	nxS5xo3mPCnNEe4WCMXGr2K7Wu9n1B24FKA1zCWNV+2QDY6egIbZhc2wJ6d502kmj3sCwn
	t8EUL940xIdsLjA8bv9rn5dmCbn+YH0=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-37e0a189b0bso1289931a91.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067691; x=1784672491; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
        b=qWrNd4in1WdyfZshOY/v6PhvNooYK8Ofm9XTnzUYswkQKMumbOwgjhdTHRnI3TZniW
         wQivV3w1Ko5MBuTjotYSNOn+LW4mqy9+g0gt/uwpRXNpfdw3L+PUGVCn38PzZdkS/fc6
         Ck6EzVIy+bfdeXT+raiTpJwupn4qKzr2ynUPHvJvDqB4nEn8bVgVond1FHjJJRAez5CV
         +wE0H361MaDmYg439ijTBVpvOt1UfUoMBxWdQn5gFPs9ZIIths5RYKfT3C3+pu220jvs
         z5HRpUlajjbTM+wBgG1j3B/3oN8PcXpbgE2B30pvhpgacunWW/0LHNCVAzT1tgrSKtmL
         AiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067691; x=1784672491;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
        b=bcfVjtu+4KJeMv/b44EpOW3QbRLr0EHpbSON37BFjSF4Ogh0JCwy0y5li7q0d2H5qh
         O6UyoA7VR53UYmyyDHYJdcb2YmSHI5tqGkP6qrgvOwGAsFHjsK73pul0dY6erXKPjsGb
         KDtYvpAUdWgtVsMKKYn5eCZ+nHjfWoyBofjhjah4rF6OGfwtQE7pSmxgHod2PX4Ps8i3
         xk8AUAvvPrimLE16/X3OFvH95h+4JFGQktXuwlNM2TJoBCACYAQOZV9iQkavWUgoimi5
         QCKou/NOXKvcULemkq3JsONkQRKnybSoIK2VpqZWELVReocTSY0iy/st4xqiyviFUvQs
         XvQw==
X-Forwarded-Encrypted: i=1; AHgh+Rpjxi4k1uoflGnfuc7TFqvPUWfp0pv4YpXCg4CQ0yPEBOZXFeDquoDOFMkvxgag1CW77Jm2zwWdjQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3YRIXI8uiUD+c8PR740yuDQ8an93CZGf1TkZm9dbYyPHkZ981
	3WKq6u1pNXOlSHVP3hhmrjhaei/cdH84uYhdO4aVeySvftn9BQpgSIhp
X-Gm-Gg: AfdE7cngOiBPxW2nP3g3Qe2znwiy7WtIHSFP8JBbUOL/Ma9kw81IDdiz9j37D3PkT9T
	dH1teYzJjIP0/Kfnz/kazhcspaDdW6RGs84Esa2vZ5m6BnyvnqCFsmOmhFLceji1F/3k1uCcTB9
	qfsiTFsMfewwH0hlOaJPQGKgD8FGMUTfyhWEVKO2u1w14fA1o/TEFaevihvd1QOo95rHFyV3YYE
	btm3ZjnIqMfh3kjJvOn1mPG1GylGsTtLGw1jlxOJtWdfepiSHooLdySYVRfNIVRsb8FWNinONzP
	HxHr4tkUiZDorKo7ycXe9wSx2B+/DLR8Mpu7768+PwUZH2lPeKJZTwDIzZU0jf7MWw2Pdov0zda
	YUo/llBmm9kw0efb/cO34TQTVh15e4fTUr1eLAXDEB4xnle8MKBkFuDVHJQgiiO46v/Bq4oFXQe
	c1vxPFYlMmsVuqXvX14BUEg68llyMdwwU72hZ5FToACzBLoZpIPGbskusj3NE=
X-Received: by 2002:a17:90b:3d4b:b0:381:1f51:1ff0 with SMTP id 98e67ed59e1d1-38dc782ab85mr13404006a91.2.1784067690606;
        Tue, 14 Jul 2026 15:21:30 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6d08sm2132074a91.2.2026.07.14.15.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:30 -0700 (PDT)
Subject: [PATCH v2 1/4] fixup! mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 15:21:28 -0700
Message-ID: <178406768885.1106335.9955379956617151440.stgit@skinsburskii>
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oyzuz5iaqsi69o7b1j9kiib47i5wcuz6
X-Rspamd-Queue-Id: E04E8C0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784067691-604087
X-HE-Meta: U2FsdGVkX18DF1XWV9ZKVjnNrHISDl+tJdCcrZwTB4HwscpRDB8zIJfcaOmxcxiC0TP1wvcdZBXnSpchr1YNHr0ruXdnc5HFWSYmaEk5UhT9s6WseZJW5K+MalY8Rr+pYUHZDiZWYhqq9LJANZYf/VjyPKVdBBU4t3cTe3Lg/HEKgRQ34KOblg6P0au5QHUHg9CWRsux/W/vI6V5vRMYxNJpBhaVgutB4Ni6UmqjfmNk9ygCcjbsL2LPoBapOyrg4MPdK0KJ+/nvl9HKt7YWWy4TBQio94iTrPGvGmA8lRjqECu7Fl5yMPpjHj+z3iu1HJTeM5KdtH3szteE+LqYEr3hmrRNSI7ffrqkllDxwrze+Yc1NjJYhVHuZSnwkH6e2YQbOHqj4ymBbyICvuQHOP/lG20KvnZJwoD+TEAh65wpLqlMfEgwN8aK86FhdRuGM1IsbwPfhhW2HtaAO3lcnyQWVWHPTl2L7/wyT50HwYnAxlyIftBYQDJXaBBwzZ0pCP97ac/SxnW/plM5Koj3cFgg3agmkfC/GdWCPmtUBN2Z/gfoWqpR6kiVr7J2R75rRC50t1WnqB86ac4FijBxL29U7P1YUZVe/qepAYXzZUrBt6SCjSRVu7kIoKHobWTkzKaFKnF9KJ3hlr/yZsFW0c3w9nJzif4lnEDoWGxH7Hk3UxjvSKnHJ//0ckLx8UHMzikhjJOxKb2uhH7/NB2tR3bhppz4s3xAjcQLjiyzzEFyduMgciFF2HS+qWK4xZRUeoCMggHw2KY9/Y0+Gaf+5poKTUP2PTXRhn+TQjNQ7HzQ6v4DlP8ug9ll3BzZ/dqrE8DGSaRhReZFt9NBiHhB1WLENSs2fnQ9/S/tLoATMJXoKJ+WXIWJlXPRmYpvpA2qw+kp1gStfdz0h7TpsYqGrL5I7EeVkxb6Gg/LA2OPeErW8EpRDLb9bfkB1aCcQGPESQYvr4hGR7n7QVEfuH5
 N7GfK/Al
 00wFtWn3hsA621kNq876vWnR2iaXRQReE4bSRwpqKe2qlfx7RjdM1I8ohqNhgCcuFPcPMbA7vLqbr630wtTbkWtfOD99uWu7upyj59LO1dOPf4p4qh5Z7hP6l3vzXGQ1Q0wHuSMRfuVWKs7J/afd+CaeaIU5OHK1R/678oLlr9ZdY5LBobFau2ZqdiWYV0wzS5Z8mHViLp058tQvPaacqY0ZI86efXMtaoZYnijF8Ulf+6uw60nZRY4DDDr700WlUqW7T/RHv1op0LIDjkICR9PFnaqV4VMEOTTBQRWyr39/+ogXgahb9H2L+N1hLpTA16Yp3XUsLWrk8fs6xv226L5+Z06z62ZFVv5tM7/rNF74Zc1tZdaIlVExSsILgyepzP7g0ny1HR7RpBxTcTqxFWsHxDQ2pV/avS3960k8RfBD95yfXAUcuqXNlYXegmGEhXHevRZkgHeN5tz8zgRyua/hmS7E3C/gkd8kGs4E3PC9sFFJtZnuFDX2NSCPc5/KTs4TajAjMR8yBHXEM+7X7qjNHfCamLXR/GsBA6PG21Mu5oRL7jfkC/51FqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hmm_range_fault_unlocked_timeout() example checks for a concurrent
mmu_interval_notifier invalidation after the HMM fault has succeeded.
The sequence number used for that check is stored in range->notifier_seq
by hmm_range_fault_unlocked_timeout(), so the retry check should use the
same notifier stored in range as well.

Update the example to pass range.notifier to mmu_interval_read_retry(),
and spell out that the retry check uses the notifier and sequence number
stored in range by the HMM fault helper. This makes the relationship
between the HMM walk and the later invalidation check explicit.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 5c88d2cf0818..fc1b8dc19825 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -206,7 +206,7 @@ The usage pattern is::
           goto out_put;
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
+      if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -225,7 +225,8 @@ The usage pattern is::
 The driver->update lock is the same lock that the driver takes inside its
 invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
-update.
+update. The retry check must use the same notifier and sequence number stored
+in ``range`` by ``hmm_range_fault_unlocked_timeout()``.
 
 Holding the mmap lock across HMM faults
 =======================================



