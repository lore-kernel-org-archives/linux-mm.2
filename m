Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD0CC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08CE6B0199; Thu, 24 Jul 2025 08:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0A66B019A; Thu, 24 Jul 2025 08:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D516B019C; Thu, 24 Jul 2025 08:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B303B6B0199
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:38:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35AEE140396
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:38:38 +0000 (UTC)
X-FDA: 83699111916.06.608A6FB
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5EF73180009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:38:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XOhmip1v;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf16.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753360716; a=rsa-sha256;
	cv=none;
	b=S5Wqymb9OlXZdNCJokP8rnY9LUPPJhcqpBKOhE3KGKQkBX/XJAs6DMXvS2CS3VmF8TKpbo
	uS3o+JYPSKhMuTEyLyGzzZxrWpQvy06QgoHYUwTDJTQlzdjEu0bIsHpTiH0aXDs2KIVTDz
	6Jx2JtBCJsPAUt7Zc/9nC1o0PeUAEjw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XOhmip1v;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf16.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753360716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpVluK64wbdpkdLsO7dOz1cGp/QvzyiM9Vm+tiWw0F0=;
	b=IQ01NN5Z3fFdWVMLlHFL9fQTL6Ur3DTfxvgyUMN35CoaU6mYGpTS1GKNshx0YgvK6Vsnsl
	AnDV3IbLzUvuAok8TOfmzXZtg32bFPjGFoGKuBSdfaMdBy7CPKGAQEehXxUl+UJLqzQBw1
	H4oTZzS9JKRUst2UXctZ7WGs54h9bu8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OpVluK64wbdpkdLsO7dOz1cGp/QvzyiM9Vm+tiWw0F0=; b=XOhmip1vJ7HCfZq/ITREXL45gG
	pvCRuaCPysU2hUV/3sUehtINSqAZG8zriQUe21ybHGtJuR6U40TwqytsHVuOom7ocx3cJRbeRkQbs
	iCNxhS2Z+aSAH2qEJ1D/s1z5x5JiXExEWyzW15xE9bglEx92reIjlH5dvgQATLbXeiFLcVY5TgBWE
	zwuG+P1xQuDzmtgPXUsJZ+87Wg9XMQA1Ebz19fnvSqYbpwkHtI4ZgoixG8KNMzEVK9lRB8PPZCxvw
	soXVwtmRVoYvFW2IzHim4lwZm8Uo0JA1+RUaSl1uXkmfQyhdkGXVJkpttmCb0vNkLy3uoOJSNVrqX
	BCbk9jzQ==;
Received: from [223.233.78.24] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1uevDH-003BUG-5O; Thu, 24 Jul 2025 14:38:19 +0200
Message-ID: <6fec26c9-b240-6548-c970-882c0576ef33@igalia.com>
Date: Thu, 24 Jul 2025 18:08:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 3/3] treewide: Switch from tsk->comm to tsk->comm_str
 which is 64 bytes long
To: Askar Safin <safinaskar@zohomail.com>, bhupesh@igalia.com
Cc: akpm@linux-foundation.org, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com, bpf@vger.kernel.org,
 brauner@kernel.org, bsegall@google.com, david@redhat.com,
 ebiederm@xmission.com, jack@suse.cz, juri.lelli@redhat.com, kees@kernel.org,
 keescook@chromium.org, kernel-dev@igalia.com, laoar.shao@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, lkp@intel.com,
 mathieu.desnoyers@efficios.com, mgorman@suse.de, mingo@redhat.com,
 mirq-linux@rere.qmqm.pl, oliver.sang@intel.com, peterz@infradead.org,
 pmladek@suse.com, rostedt@goodmis.org, torvalds@linux-foundation.org,
 viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org
References: <20250716123916.511889-4-bhupesh@igalia.com>
 <20250724091604.2336532-1-safinaskar@zohomail.com>
Content-Language: en-US
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <20250724091604.2336532-1-safinaskar@zohomail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EF73180009
X-Stat-Signature: pxa8xin5u5yrek4arw4jzfsrcydkx8ps
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753360716-411003
X-HE-Meta: U2FsdGVkX1/B0WE8IBD9g1J4eclRjPS7pOTUv6msv35pWeo1hI+B6rY9k58RNuzNx0MmNfoybN3hsQ0GaUD/0oU9+2Im3zBIX9vFGpTuwoeszb+3SmTQxsSfQmzubKa7MaDiJ40z4RtXofVyS453Eq8RiiVFLYU9Ndgd8oRXRhPUILd7cP0pfGLzHrPGBEGiJwGjAPAfD88E+digZJbqnNwq5+HHDXVsL0ISGWtMfyDdxhy/ybA9hm38lvVf520QiPiuiJKnDa5hEpEs87SchY8eab6HykV4BHxygoRRTXNv0ToVY+iL3LnFagdJfuKkv/C0ovf0tuJzSyAzyomroVg7IdtcTTQ+y3uN3JibvFMBHNWK5tORFgK57OBLELgZbEZm3ltMiSICUF/OfITetl+qcjAsEfZ4hhjIjueOTbZA+oVhSFwz4wAc044O2epRhgp/QExIIC8LlZSXqG9aKr8e5GXxxSDo9k7DDPj+G7RhQENp3w6LwWhjc6gFV0t37tDKQVexoQpisElCSzf9BT+hZDzqOX5fIYyZwDSYHadIXXTDi21My/4FE1aUH2audUcTPJt6BlAHheoc7lhOgQrUmDE4sDBDZ8tjUT/KmRYKTMm4ZNw7UakeMQq0Z1vA+pQCNB9i36SbKVUPZromN5KvSVXC6SglBY15MzjIDXKRqRBxEOuDAITnCKYy3H4jFXbTG7J/uQdFBJ8X2jiuptHyYvyWVnSDrZxiN0qVnIf/Ct+ojVByrkVEob6LBlGBciBJb7pb9hrMwm/TIwiVeQR+jzgVfnBkpiswrC00FReT2aItCgEq4hxl8XO6paB9/IDF+XLHxP0cFLxCQmFSQqJzMCuRKZHdmB/rSyl75B6kP8TSOguO16nruT6Iw3y+GDFwjJUtpdrsVwPy9JS0eZ+j6MUQXUFmVGIecy3j2FZ/Xi7h62RZf3TvgX0GVn75sCtOFqHgt/iXpNBisFa
 hh4r26oS
 PIf6+SiKP5ftYUIRwj/AvFS9W/6n34N3KTLjuVIQOL3K4dfgygEWQDgvegEERB3cbmfDOjSyhKN5hs+G9Hhld69dn+BumCBRm2alXPYpi/ZdgGqPIkXPfp0jM5piX6XRWbOOyQ6LirfcZAwGfcVmJr3+3USNwOrlcyq+j27V+rEDzrDucp3qKRnvuOL88JewH+ygQxGgtaeoAan4DEFxCBBUjkDDXpmP6P+wij8uioALTB+bI4EfTZu+7ljP0dMIevWxvCKFwDnJpiXnPo4Q0E1fzhuJV7Trd/je0sE+qIhnQ6EgIeV1E/POEdOXQfeSLtj8mtULHz7stniGo7rzV51VITyvwau4pUczLPQPPXHbUK/RkrjCIMp5t6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/24/25 2:46 PM, Askar Safin wrote:
>> where TASK_COMM_EXT_LEN is 64-bytes.
> Why 64? As well as I understand, comm is initialized from executable file name by default. And it is usually limited by 256 (or 255?) bytes. So, please, make limit 256 bytes.
>
>
Check existing users like proc_task_name(), which use 64-byte comm names:

void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
{
        char tcomm[64];
        ....


Hence, it was decided not to change this and other similar existing 
users and cap tsk->comm to 64-bytes.

Thanks,
Bhupesh


