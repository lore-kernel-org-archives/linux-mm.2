Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E95606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Gl8OIyuE
Received: by kanga.kvack.org (Postfix)
	id 567A96B05B4; Tue, 10 Nov 2026 15:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F0D6B05B6; Tue, 10 Nov 2026 15:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DF16B05B7; Tue, 10 Nov 2026 15:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 191926B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:36:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99A51402D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:36:20 +0000 (UTC)
X-FDA: 85420366920.19.B6FC6C5
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB41F4000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:36:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gl8OIyuE;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OZSyM/+htBjNF4ew/qY/xFoQA8rG85Tyx1BVaZ0pBw=;
	b=CefaHxN/VUlCAk8O8pAyhtt4xuoxlFy7R3D7bzVYuPYQ9mVV4kH16czGQ0SGuzSpgjl/XN
	QBVd/YkwDW159EhxizO3qCKuHupq2QwkUDO8zgg8dyE4QgtjMJ654H/OSNljMjg0bZyRWt
	HnK4tdp305DuAOZRcjGl6l3qfjwvBGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342978;
	b=lJ1Kfw3Q0CIsKnkmwWlxblF7gUOmDt0Mc6lIz/j2eZYGSJA7IkC/9oNbhCZQK6e4My0viX
	/XOweAkbsiY64fCgRhV0Dn2OJogXCeXn2Hazr79e7YJYthUt9JfqWXWhVR21cOoKMTXMEc
	Zv9nrhOIcb5S18GPRWOUyG1ZygKdRG8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gl8OIyuE;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91eb5559b34so18898726d6.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794342978; x=1794947778; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6OZSyM/+htBjNF4ew/qY/xFoQA8rG85Tyx1BVaZ0pBw=;
        b=Gl8OIyuEr8Pg32zfqTksVSv87vLrfljmhS+r7S4mq9JD1R5dh45yGX8Zusy7uGR0Fb
         INhz6nx4UPWXXjDihOBJLMYX8z05UcsHosz5VFwq8oSL6txROlMRNQG4csvDsXqB9SHF
         lcBNVvxNRRzZfzs5pl9Fi6Cn/8jBoWuhMwq/BASqPGX1S25rnBGlvrOhYnXAOorN1Jge
         8zcJQKD5imlH83RR0Km7QQzOEkmsz4004duAsie6c0/wV+RVao+NLsNlvskeb4Ram1bK
         CbBoS51M7F25u9HXJ32hFLyzNLeacPA4WR0tSYR8Qsv3rIFgqN3YHTxCRfHeMcp9gbIt
         kpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342978; x=1794947778;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6OZSyM/+htBjNF4ew/qY/xFoQA8rG85Tyx1BVaZ0pBw=;
        b=v3sIhONuT2+aMUM4voMBmPTEHDTiMx/h6DQQfe/wXiUd0+fjE+c37komE5pT/Kp655
         FaUqTS9j+hNgGgJuGEVtLcobnDB9WtDpRvAzPBbgBn3YZmESM0uUZdeAR8qaubDpkUXw
         pFEqeYhZefN8kUUmRp/6Ore0j7+pkAs18+cDv46n3EUqcAI+TOCO4Vg3G8yJfYuKcgte
         LBHspugUWyWdZ0D3AMJJqaIzIoWlpSuhR/pH4L8gX8LiEj2CK/FiaoUuYEQJCb8zAVON
         6UbO/k2F35GXbBPexe3nX8sXTKTAP2lzARB39bANbJ0owXu5gHx2r3UncEL6kPDmAPbh
         ZALw==
X-Gm-Message-State: APuU4Z8MHtuKrCVzWJxMHH1agV9GsFiMJlamvgGNYhxDmV926PxLFmKc
	DYLIeAdFpgRMsXVyBGCpBbpnRuDeFf0c/7BNPmkrvMdHqCUAjjxBjijsa9blAGZpByk=
X-Gm-Gg: AYBFou0t+nhnRX+SIowdGK/e7wzuuQPcskB4ApKrFADxLKlh/xfsY04ChQGGM8yEZGj
	su+5Xk7wtpxE68Se27bbEuAuv82ieHwKyCmJuIu1Q0T5LANaCgXUcAa4bf4/C6+czn0OKbybV/l
	CrpGQIkhlQxf4hv/ZrM8sTeuytNv2ao+mgvGxpTxNMkavU9+xQZlCs3DuanHId1vUlrNSzuJAqA
	RbdknFO5snsdcaEqkGaA723kg4yzN8jkL1EYA7FHDqJ+oeRzR5STXpkFlM2qJl8B01ZtB9b73KE
	SMrmKhS5IPSNXt0WSJbW/zP6OiOxqSnvLmd2CuLQmuPtedmXyUBsgARnxW3ztuOfNduVeUP41FT
	VjqbxqLSqYgq94Giw4QR5FQ7uvTDeQxCdoi4hyKitds+sbNji0WiCc6xoXi5ivJeiurZ9rY9T0V
	tEAFmPmq7zv5jJhyBCMyV0Q9T1ZHyLLmxstdGEYBsh0J22Auo+PNf3HyF00yyJEjYKmfjODXCyn
	uSO1VBJ4MyvkmpwfqyxgB5YIAmz4g1kAqj4USPzf3ovj1+kWkqLY3T60XMBX8toZI8FKFFNSdHN
	RlVmvjAoTB0NdyGx/ZOrpkmMnBbIWOjvGPUiwFjZcQr/laK0k3KKZz+p/0qJH4gRTY5jaFkNw5Z
	GTvMXNEY=
X-Received: by 2002:a05:6214:4487:b0:91e:a3b4:9f1 with SMTP id 6a1803df08f44-91f03c0725fmr9307786d6.0.1794342977608;
        Tue, 10 Nov 2026 12:36:17 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f04c2b8bfsm1195296d6.22.2026.11.10.12.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 12:36:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 5/7] sched/numa: scan PID-inactive VMAs for
 promotion
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, peterz@infradead.org, juri.lelli@redhat.com, 
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
 bsegall@google.com, mgorman@techsingularity.net, mingo@kernel.org, 
 vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, 
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, kas@kernel.org, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
 hannes@cmpxchg.org, osalvador@suse.de, raghavendra.kt@amd.com, 
 stable@vger.kernel.org
In-Reply-To: <20261110150446.2452975-6-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-6-gourry@gourry.net>
Date: Tue, 10 Nov 2026 15:36:16 -0500
Message-Id: <179434297609.2530531.2349001562856798404.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: yqras6txz4jd4y5kn6ots3itt3cqadfy
X-Rspamd-Queue-Id: AB41F4000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794342978-684380
X-HE-Meta: U2FsdGVkX1+HZ4+JDYeyMngfjqoNriTXJR+W37EXnOpRz3vaoBKnu6x3ZL48TYWriXIlYdYEcluB05pjQ6093HQJ6b11lS92nH1PFsKJhNrefx2lWXWGAkDnWhM8n5C0G60pqfPliN5pZOIDw7iIifJvrxY1n2NiwCcy8NDs5LO8U9TNoLQV/wX981vPbi6Hyuu26UbWA5pC/+SEHRZq/rPaoGuXKKtYy0QbvGNM2KnI5PFdXW1ui7rQuXqSxuAdy9pgSFlRljMlORVaS6siXIfdMcza1AF/+rGANDCFroJD1+y9Rjct6TuQJniJNQe99FEwvEangnDmdMX1ioe1uht10lnTwkKK9cXuCCVDZ3bcMkspKyqv5XKnRfUls7neqGaye6wR81pYxDqUSE6Q2S7BdknminooAlFaFv1sy2qPd0gGW8TG7S1KJ/Z9JgcLWIIyoFcrywogIwcLoY5sKqADQcV9rHrRdEyBvtvVoOlHLr/IU3tQSYRzJSZydjp4KcKoylj2FH+jzhI1eSCEwvD+2YJVevWP+fB/hlVCFVIEKuCE98/6m0atfqczoM6pstrHGnxc9wgwGTQTPgRnElo3TSYNOq1g23KbyhM9ArXTWub/FjT0AoXSDrLPMFoJ037Wf7dUjI7YWP7ayWDBbbDx/KB7Qmli/rA8tPmtDi/BzIx/GXatf+6M6uTyKj/WNcAMaTNMaStK5TUDgkh9KSfcB3ZWp1a8B9CX593/jPDwju+s1/8BvIJ18OltdsbGw8mFlhHW5/a9VqX+ZTo0GVaV82WsXbx0QZOWqvkfVqifXIPL7SY1lWoy+84pb//ocwYEYxZrb2a/l9oeydRJ7+aMAGC43/jaDGRheSn6mXfFwelcGGiYM/8+tR5sPd1wkWEU8Rx3xcy8SCTzuNS6u/xWn47dIbyDY/3rtDoG7w9FHZTVciHSCsaTNB87TKOkd98Dov7z0lgD3Gl8Z+B
 0bhS+OzT
 dEADKxH4uBy8/n/ywEO4t3QCIZfZx2jFqxpNAJp+PZAdRbx03M1QIJ9pBX/FZ/kXo4qzxNlIhT5rsvdNNUbQQKozNIcVLqGt9G54xcUuOFYspgofGa44lECHIhzSxXzKh6GmEqKF362/qIKz3KKIvBiSW+MypF8ox5Xa6OWVOecZS4bXlE0MZL1cIQCkyOJw96ZKu1NC4VWkTK8LhDT0xzmX8D8l3AFnl1T6CBkJxWwcTPMvWjPaPTahtAonZL23gBVZ8zUK27FGeEQ6TelwGTg5JorYx6ug7ChgYG2nUpIb2+XYWp+NbkEUy5qvISqyo/f8GLwy9SyllYD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 10:04 -0500, Gregory Price (Meta) wrote:
... snip ...

Sashiko report feedback
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4249,7 +4249,7 @@ static bool vma_needs_placement_scan(struct vm_area_struct *vma)
>  	 * threads can help scan this vma, force a vma scan.
>  	 */
>  	if (READ_ONCE(mm->numa_scan_seq) >
> -	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
> +	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
>  		return true;
... snip ...
> +		if (placement_scan)
> +			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;

Sashiko took issue with these skips, but its reported impact is
overstated.  It tries to point out a pre-existing condition:

  prev_scan_seq skips an update on a rare corner condition, but
  now the same skip applies to prev_placement_scan_seq.

In modes 1 (placement) and 2 (tiering), the behavior is exactly the
same as it was.

In mode 3 (placement + tiering) the result is that the starvation
counter isn't reset - but everything still works anyway because the
VMA is still being scanned.

I can follow up with *another* commit, but it's really low impact.
Not sure it's worth the churn.

-- 
~Gregory


