Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAFA606A690
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TSxKO73D
Received: by kanga.kvack.org (Postfix)
	id 486946B05B8; Fri, 20 Nov 2026 17:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4373D6B05B9; Fri, 20 Nov 2026 17:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326CC6B05BA; Fri, 20 Nov 2026 17:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1C636B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:45:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 563F21A0206
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:45:47 +0000 (UTC)
X-FDA: 85456981134.24.63BA117
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id A540DA0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:45:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TSxKO73D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214745;
	b=A4KXnnR1uzTuQ4V9kZLMz6wh6EDj/8nWpJE2MJwhoWtL9omTamuUNnlKlTD9tMPNxs7Zt6
	Fq0Rs6ZG1nHlgUtcjl9FgoVGok32PXEQWRDCltibLFvBAOmGncU/DW0EWrP5xhn4LbwtRk
	gzECJnyZGDQ6L1jEhTMDXes/E00IH84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UgdoOnjCgIv16rU+twY+lm6EAFUHvslWGQR6UxjP6Qs=;
	b=S7F09HnDC9sfImkfuVIA8gpOiJMm9ns77HU1057D5ungZSZEtElffNMrylnxTzSXV1LqCn
	3cu7CSwo368YluWoVfPtuDmEhWgOz3CWEzbbMHV2Or5UgSqWVIVBLbJmfZuYrwE/Kh2KN4
	F1vRJDDPLMg4xyqnQBst2ekrjZxXjLo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TSxKO73D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2efc4a84e75so8925ad.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795214744; x=1795819544; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UgdoOnjCgIv16rU+twY+lm6EAFUHvslWGQR6UxjP6Qs=;
        b=TSxKO73DiFjafr0rLO2ADjim2wmW1Ovnc9G20mEKgXq1Zb3R50PId3fM7IwoFELmU9
         nmKSR7NhBa03jyet1tIpzOBf7VnUEV7bS4bqgBpksjwnF0lDLdfd+cn+BdTBQljwCyx/
         hc1pLvmAHMoasySfREtpi0wiNG6fOiWL0XjyVBgN5D2BDWX94hR8KhNv890siiGMe0Kw
         /8CTP64R32MLPOx7DQ/ujFSlYRBuAa4/Vn8DKAbU8ADr17BF+JuS7/1pdKngMZN/YxsA
         pnASPLgxE5v/9ux3TQzJ/9UIc7SXOPPZgIXDMTzl4tbYosWn1Bt6Q1MYBEccVD7FscQN
         UGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795214744; x=1795819544;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UgdoOnjCgIv16rU+twY+lm6EAFUHvslWGQR6UxjP6Qs=;
        b=pzAaW+nJ2baLGSGCMUCTVfVI4tdwT3hiy+V+FpWxqP8+MCbYC9xI2dW81RRUvTiYT5
         7lm3IL0hygT3Z8TMlOI43eBOtyr+ulF/4O0fXWMfPJ6f1penPcK9YlyTEK0wAbTf23Ut
         JfGerzNnfjLlcCk7nul87nrmqrDZfCz9UB/m23HCC4InTJdQ9gfcz1JrlN0ZNpQV8uvm
         3YaHVMIdzSESu2ptNMy7xKQcxZzlCxqmKOlpUBA8xKL+DdpmBIOAzDURrhFkqwHDW5AU
         rwUZ5mJC5TsbyO7jggvw8kouE+k1X8zhkSFAENeutOxoTcvfiifbSp0NiSu51axYzrqZ
         LfLQ==
X-Gm-Message-State: APuU4Z+T7KbQhSRjTAhKG+zPPVEKwaexbqt6xZpRH42taW8t0Tfz9SuP
	E5jlUqGB8xgiRtKlxE0UefWYPs4CdfBY+ES2YEv1npqIsN9J46QjEFP4/AOHk9YVpw==
X-Gm-Gg: AZFdTZfwRXzL32Z451FFfLMzxWlqgN71xjcFRPhq+LuStwGvkRtQ9MJtk2JMIT4LKIP
	NOMjx0ZLBzQlBqoL+IH8n6h2ILNjpGH5wOxWpRa0vVy+LNRJ+rSVBQ3NuHGDc6+CpVPknF2IPYF
	4LkowU6CnZVVQZJb4In2ZvSwcPI/bs5rtSCsrvMqOybNnvO/fIshEJzxv7ZdL/PgrRFhoRw4kaQ
	sNn/mK2exVu+3Ufr4eL41EQ+OdDk0KeXl8y59RJ1OvHDgA0JN8lkSDt52bOFCrLIMe3nttOjjfp
	AuiSF4blz3Wyu9vCSQD8rpNO53ujaB9N/zPpPUDtjoP3IpCBCLLSbXBPnta1ADpEWW6V1t/s6kl
	/4oqwybtF+4bN35cZWYSfoS1gC+XKnv0S4hzTzCvenClSgnvHe6Oet+JAxvMQAMKd5BVgv4AYZH
	Et9MYzMVGxjLlVPZjq1B14rXw2eZ00tdmXrOyw3+xjEXa+PURrjvozVeqOdHlmTWcprrzeVk4RX
	j15h75h7A/t29GYMCFaJa/29nOQ+1v0NVeOqoqX6v1/Go1Wl9DF414rKYEKTy9tzhiuGYtda8PV
	E/nAH11WY96+IeXcmxvXmbf7odL4u2liNnqMMliyiFUQbqIKqc7lfvHXlZQRkrXzvBXoLqbc3oX
	7/vZsQR2SCNzDzc+jKt4jMxzK2G+fvc1Vk13Da7riCHBY/CFiUMCToAqnwI6hhttmJ8wcyuPWnI
	8F0xDVY9o6cqngkxCHbxpiP/ex+USF5HlkC6pH2Gil
X-Received: by 2002:a17:902:d98f:b0:2ef:d8bd:38fa with SMTP id d9443c01a7336-2f0666fc5b2mr653365ad.16.1795214743943;
        Fri, 20 Nov 2026 14:45:43 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:48:dc44:13d7:387d] ([2a00:79e0:2eb4:9:48:dc44:13d7:387d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077babfsm2107815b3a.5.2026.11.20.14.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 14:45:42 -0800 (PST)
Date: Fri, 20 Nov 2026 14:45:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from November 19, 2026
Message-ID: <61f3a1ec-a548-ab8a-6194-e38f4b9267b6@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A540DA0005
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: cwf8z4ie17s5k36nqeiuir4f4b6sz5d3
X-HE-Tag: 1795214745-635479
X-HE-Meta: U2FsdGVkX19R2jNHpDxcg9DM7pbPgg2qeWWtkHsXRzz2MK78nqsFlZd4JCFDXYtkuRG0eaZTWpp22tVWkcnbW+vRczYjweBhLwwA2JOp9GoTGR5GTa1WEv+AgfHRLZWcSfLvAaC/npkk9/A2iZh+s4Gz373sloKB9PSTWmpAe6/tZkNjlXxYfiKdwXoJTNd4LuLnF+YxgwGjdgk+pguqFjXoUTKcFjJhVfFct2OfV3q79d6J1MiqowJ1Y5koFf89mEWNz0WEWP7z5Fj76ny2cCxUauwvEINJ+xvicV0lP+V4zxX8M4YejQdc9Xc4Ige0h4c6PqX/wJO+a5G7NeZEDxqCAPPZK2MCQz9X1kCtunn6DQ6MVSPesw5ciHsKTrQ5EJdq5GgDHZn+Wm2Y4zWrqrJ6VU16KT3XTNtoqgkU33PYQBhuNoW6Pq/S3Y5P+JjDKJM/UF9ptGBYnUNORRl4TT4tE4QhoR9RIhMrX6qZd1QuyyS0zBYdXobHxLN2nkJ4PFuwVrAzE5gYqvE2TXPrJ6qQGXJYVWtFKlTx9rbr3lNqXoweui2RflMqn1aZjT2svwgUH6NUqxXy4cWV84mLHq0H8OWuNPn7F5X+vTLRJA2j/eTaAy0ZcKuWC1cxZtxHUeCrG0oDlIl0UWZEaX63SDqHUg3BvBWASb6ecysLnbY5IQfVecvq+m6dkpDxM8w3tU26G9xe9u8LAi26dvd066KZgRglBbeMiNyk9NvwGMp+J150eQtjxtv2KhYljnc5iQ3HQEmFeYqFW3bdnE3TyzXe2xjUYp4P4IIHQpnpNWpLpevhWVzXOLZzDRvr02J1GhvG6KAafGlB0oqI5hU9S1hUYA5/1vSUlKjlJ81hKRKGOX7W9AW45LSBlIYgsv0uS+L4uWwDArz3w2HvX4bJBk4cxx6phjfvH9kdjpqwvmw4To5Wv+8HiXkfxsC5lqJdbGKTV9bMbmqOYugjXA8
 UOIrxGCO
 hukvH9betlG3brVYnh7+kQJ7C5uPta3yzK6ZCEP4nDv8SZeGRnylhX+erkWOJ3lWVpCFK2m4umbhm1p/A/l0fCWYoqMu0CYFzn2bJeCIJk3F86IyuibutkWkKqJ1pp6txGOvKdwl1u17qVNI8c4XIvE16G9Ui9EM7VRGWXvSD+BJHZH2CY/xyCivK2yMQXPIVlfnPTaXP3LMutrMo3F8bvmsOOVg5BduUkqgdgm1m5Tc+Yj3N1WzvJEqhcLVLR+SlM/l6EWNFNJtlvFzD3mqi9gPFvgLA+j75b2BW3ZmjDtvYwTG61ujoJ6gb0Sn+dz3v9IDVB/YcU7KgS0U+ulpHWaCQpni5gQEY/MnDwJrlhuRg5QRS0EWySLg8QObUTz/oB859ngvAoizKb/Li3XxS/cKnRUesuCAdzDGIOoFs84UMhL/RgfZjgraB4OQK7jUr3XsyYwm4Oe/TdFNrovIYfE5e4P3BpWYyxQo8e2EaVtA+oOt5So6sCpf6VAyAW5JH1ULd3dLZI2yL2t/wIuDfiDoFu/RgWYxZwFVeDh/62eKwjBrH2+1cBy7+uER6EndkhIZxlGmSweR477YYkyVab5csZmsdhsz8DnbxtWbdff/mGNijQgX/NWToQp/LfncVn48Du7aE8viXV3ZnwAF4OI/j68YK9FSuLSuz8HmpsPhHgKGz/W8bSVQ2HYX4GLETT9j9UUif8PcF47w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, November 19.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata was unable to join the meeting due to time zone differences.  He 
submitted a patch that changes the existing NUMAB2 to switch to async 
batch migration, moving the async migration and promotion portions from 
pghot into a standalone series focused solely on promotion.  Initial 
benchmark results for pointer chase with phase shift characteristics show 
parity with baseline NUMAB2, and they will post performance numbers next 
week.

----->o-----
Huan contacted Shivank regarding temporal stories, and while busy this 
week, he will keep in touch.  Huan is moving Yiannis's patches forward and 
has a dependency on Shivank's refactoring work to incorporate refactoring 
into his patch.  Huan requested Shivank to split out a single commit 
series for migrate control refactoring so Huan can iterate on it 
independently, while a separate 2MB overhead removal patch requires 
further changes.  Huan is not currently blocked from getting upstream 
feedback.

Shivank is planning to post his patch series this cycle, though review 
bandwidth from David and other maintainers is currently low due to 
critical fixes.  Shivank outlined three pending series, including a 
batching folio MC copy series that copies 2MB pages at once, yielding 
30-40% benefits with THP and up to two times benefits with hugetlb.  The 
other pending items include a refactoring series to help Huan integrate 
non-temporal stores and an rmap series dependent on Dave's series adding 
batching helpers.

Yiannis addressed upstream feedback regarding performance measurements by 
explaining that they cannot share production workloads.  Yiannis suggested 
showcasing positive effects on baseline demotion benchmarks and 
compression devices instead, noting that end-to-end application impacts 
vary widely.  Huan noted that Google only observed side effects rather 
than direct measurements, and he welcomed Yiannis collecting additional 
lab testing data to support the upstream patch series.

----->o-----
Shivank reported that conservative fencing in the SDXI driver caused 
significant overhead, which Nathan addressed by removing the fencing.  
With the updated SDXI driver, Shivank achieved good performance numbers 
even with 4KB pages.  Teja has not yet tested the latest driver with the 
fencing fix, so Shivank committed to creating a GitHub branch and rebasing 
his patches to share with Teja by next week.

----->o-----
Gregory provided an update on private node support and CRAM, noting that 
he is cleaning up edge cases surfaced by AI code reviews involving 
intersections with KSM and userfaultfd.  To ease review during a chaotic 
merge window, Gregory broke the work into roughly 63 patches across five 
or six chunks, with the first four chunks introducing three node states 
and baseline memory features (compaction, reclaim, mempolicy) for HBM 
support as requested by David Hildenbrand.  Gregory planned to start 
posting the series using the B4 web gateway recommended by Jonathan 
Cameron to bypass Gmail recipient limitations[1].  Gregory emphasized that 
this baseline support acts as objective improvements for both HBM and CXL 
support, enabling userland to explicitly tier memory and perform 
migrations without relying on fallbacks or userland allocators.

----->o-----
Next meeting will be on Thursday, December 3 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on Bharata's asynchronous promotion mechanism separated out
   from the rest of pghot, targeting posting the revision before the next
   meeting
 - discuss current status of CHMU driver and its integration with DAMON
   or any other generic backend as needed
 - update on private node support as well as CRAM to be posted now that
   the 7.4 merge windows closed
 - update on combined patch series for supporting non-temporal stores in
   migrate_pages() with memory error handling (series from Yiannis +
   Huan)
 - discuss Shivank's series for enlightening migrate_pages() for hardware
   assists and competition between the kernel and user use cases
 - update on Bharata's support for sources of page hotness and hardware
   support
 - Teja's update on SDXI page migration based on AMD patches and hardware
   issues being encountered that do not result in page migration
 - update on tier-aware memcg limits status and production testing based
   on the latest major overhaul

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://b4.docs.kernel.org/en/latest/contributor/send.html 

