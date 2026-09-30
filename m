Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC6ACA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4196B0088; Wed, 30 Sep 2026 12:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA58E6B008A; Wed, 30 Sep 2026 12:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC03C6B008C; Wed, 30 Sep 2026 12:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2BFB6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:57:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 650C8A0179
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:57:39 +0000 (UTC)
X-FDA: 85271035038.13.363DBB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A62F520003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:57:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB1xzUZV;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790787457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+6lNWQyALiq1QYP3fIUDCjsMH76HqqsL8rhHYxkuAks=;
	b=0C3SU3r8XssZxFb89FH95yCV11UpR05yZ06LsxaYMsgLqjHReUAHVrCZx0U9PmLNj0J6M1
	0xxhH4iFVhlZCkjPPQ31pdMWZURsc5HirxW5PbCB11G/D0DMxpvieHbBlkzZ0st15QYh7R
	mTXuSK8/OIeXvvHRgiJMDPBN9xiOrSc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NB1xzUZV;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790787457;
	b=NzulymKmz4aY2A4n3v8b7YHPh5HdUUoAy+oFDuNZXsj0UrA73W5NAn4q/BuT9uLW6v+58y
	NzIqcpm/XoVllQSmG6MM94KTSSJ/0MqGb0UMEgaiKuOsYgf2+LRP4qOI8ihvDY0MtlO1vz
	3oQTdeJT7vvLMhq0hpyKoXc5c8WxDW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A930B42B06;
	Wed, 30 Sep 2026 16:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDD11F00899;
	Wed, 30 Sep 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790787456;
	bh=+6lNWQyALiq1QYP3fIUDCjsMH76HqqsL8rhHYxkuAks=;
	h=Date:From:To:Cc:Subject;
	b=NB1xzUZVmn6Y9RtudBGSsbVE5lS1sKCg4MYMgQXQHqheue2wd73fj5yeNPXscOraj
	 FATkLFwmIpewKlOPJCcJ7SeUWNrwsBaGUbU1wDPi9cZp9n1NMymVYChszfMCDQFBSm
	 J2md02TJ/XJafY6yoMBl64AjJnhopCuvbIOh73FOkW9c9sy+5fzDAJWTOtMNKBR33q
	 gOAnsoIzqIHmbxDl+UatCFSr9KCLlm/lsPWdep/e2tqnjs4pj0Vjlcqb1JRdk8OF3k
	 UATgZkPnBvbZb5Oc2ExRfi1EAW55laytiLNOO0UIWKWuz5Wv5J8ICuesjeTsZg5Asb
	 16bE1J6eUtkmA==
Message-ID: <471526fa-b31c-48a1-a602-208bb8113b7f@kernel.org>
Date: Wed, 30 Sep 2026 18:57:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Cc: ackerleytng@google.com, amit@infradead.org,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dwmw2@infradead.org, eberman@quicinc.com, fvdl@google.com, gshan@redhat.com,
 jackmanb@google.com, jackyli@google.com, jthoughton@google.com,
 kalyazin@amazon.com, kas@kernel.org, kevinloughlin@google.com,
 liruxin@google.com, michael.day@amd.com, michael.roth@amd.com,
 mike.rapoport@gmail.com, mvaralar@redhat.com, pankaj.gupta@amd.com,
 papaluri@amd.com, patrick.roy@linux.dev, Peter Xu <peterx@redhat.com>,
 pheragu@quicinc.com, pkondeti@qti.qualcomm.com, prty@google.com,
 psalian@google.com, qinkun@google.com, seanjc@google.com,
 shan.gavin@gmail.com, shivankg@amd.com, sidtelang@google.com,
 suzuki.poulose@arm.com, tabba@google.com, tatashin@google.com,
 vannapurve@google.com, vbabka@suse.com, wyihan@google.com
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-10-01
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A62F520003
X-Stat-Signature: 57jta8jbt7p5eb3qcert8acsqyt8x8nb
X-HE-Tag: 1790787457-287967
X-HE-Meta: U2FsdGVkX18x18EvsA9dLnXr3KBXFC5opCsLWuWu0Clt9HLtVpwkdLq6teAYdz2cD4MwNl3hf1W/DbBvCIXzjOYtRG9kn8bzH4Hs4ho3tJMS/zBPMGqNk+0m7MV/R7itYaE2LihHQvpRTD0O+MXjSVChm5K0N8mzkI31mv64Pj3IE0U9gsAOevfIxE9uVfAucmB9uECTYQjPvYnzlPtmnrXB+a63LlCsjkKR0Ot47lB4mD/j2WzYIqJvryPrJQiP1gfM/srK0qtSBmTi4msByUGdXL/TwOD+QT/0HtITBcloRTbNwDAaJlTIG2wkiz33bZjEd8ayxxQFj6pEYSejkTXPkQhuorGmLOeRpK/86x5XWF1fFosOkuFsjjHALWil5JYknGAgRwQ0NbTfPx03ls6wNJ6ypz55GgQuPRyZ1zvsYtC4eRorhrHBSbzsft73L2ziBKJMdlL4w0qL/XazifOX/+Hg18NgQgB6wwaAGU2lbrGZ5EyGjswcOr0wkSb+X4Zxbqewk+pMFE+KY2rvVIAmukU98piiMrO8yWKH+oH0zJEtJRgSiBqiqYvbw6Ug0ARH22QsYzwUnq5PE9P8CvqQEWTqdUg3u8j5Jzy06OMrK/V5IteT1JfvoZ1pCw3bCFgYFGypqf/WyNlVoeqjU90Jfnx66DlFme9zJvVZzoP+9kr0+WpTb1oX7LmEEswu/mhg/X36J1ogqGoV2FWThw8HYJu5qlVco7bgx7U4s5Q9UlR3vdqLPDw/k6eHjDV5dhYvsjg3dIKOxnvGaunHtC4TbUFyKZkqwUdk/5R2nk/jL2C7+QTNYeqhgIZiOfoHGFE8K66k9xP50oqRQqVH9hJcTdostnO8L7BjqMPS0th8jRGLBhxX7Uh5kS4uOCyTFmJ/U8D3EL9qKwgNA7T/mKkcaBNZ4CBWESXchMl48gnOqNOu6c98rnnx/Ee5EuVcxIAPxulCNAurrjttQzB
 hZO9bksv
 aF/vh8EgtSaw1JH8u+r35q6YXujkEcuXoJj8rtN9PAg9O1OYQj/ReZ0+iKVXEuc2APeVjo7rpkqgcT5HreZRYt7cJzQDGHW6LgbtkMpnL3AxCO6xE2HujxBVeN917HV9qtw331xVttLHmVTu276sp3+V8EIK5dz3kLrAthjK1NQLne2VSxwOizOFlQd0VWUjjkIr7qVYIf/NDkl+qeWd4PWre7wopyTfxS6dHCD34ZjDO6kRB0pRfLo9rq1jqVnki0zGz6WHe46d9UF0uKmm3QBlqQUZbbsUeMKQ/JJCLRwwqeq21wbsCxq6NJO6KDDQrhJwljjM5rLUDubQD7I5rnA/jyYso9/ylYKMkQowcHtDcwTHanfS+4ykhFlqU6KqqGaLvoXlS6F8BLpN/xVPcnmTKaKavcigHebJevyiZ1IWSXLzNqOHzofUuuL74aWG2RnOfPPhJ9iZj4/uvBBKQ9HZQ66mhe6EfThvi+5cFcfIyvplp8GZ/RbCLKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-10-01 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Now that in-place conversion is on its way upstream, we can organize next steps.
With that in mind, it would be a good to talk about Ackerley's proposal [2] on
how to make guest_memfd obtain memory from other memory pools, not just the buddy.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [2], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://lore.kernel.org/r/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com
[2]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


