Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125FD606A682
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IR8Cmp/i
Received: by kanga.kvack.org (Postfix)
	id 1B63B6B0669; Tue, 24 Nov 2026 05:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1674A6B066B; Tue, 24 Nov 2026 05:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D426B066C; Tue, 24 Nov 2026 05:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DED696B0669
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:08:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50A1CA8703
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:08:51 +0000 (UTC)
X-FDA: 85469588862.05.4DECD0D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B3DA40005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:08:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="IR8Cmp/i";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of ben.horgan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ben.horgan@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795514929;
	b=pcvkRab/EUVimmMmss8lIBAhacMZsnvBFG9kWeLFu8sPueHo/u6wGhAIZRDrQxl3n+GAF3
	/nbVP6q4LYT60yj57Sun/i4YdVKPBfget5PNXn/p52lYYrjQ4uAw4pctXq4o9MtB8OQShz
	QH4fee240BTjmHul0kbW2UNSp7W/RlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795514929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzf3/cqvmzHGv3qFSL5QC6mYfqjlWuS+RwxjyMzoNb8=;
	b=5WAppKci+RWbaZ2ctc3e6+ItdKiDHKJ4mxzUh+0A/8qthMawCqvB+Ea8jZPslnq+fZ2WEN
	/j5MZC3jZnQojveIE5xz1sACzCKhvWyApd+EfPVlWfIy8KiSNoy/Pqr5X3+NxLvuXwhAgz
	SMw3jCcBUrQDGOIpODPJZR8qFSx81EY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="IR8Cmp/i";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of ben.horgan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ben.horgan@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33BC8339;
	Tue, 24 Nov 2026 02:08:45 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6A3D3F632;
	Tue, 24 Nov 2026 02:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795514928; bh=vwI/GWBLyLVLTmTN2EUL2154TR5p4FeVvygLq0PiHOU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IR8Cmp/iF3CMKl01+dPH1sFgUvIbQzEGczcmIfbo4wYDkv+0Wn5W2chAQOali2dvB
	 rldSikGgRg6cMBLtnB8NpHz6KtWdbciGwkm3bII1+gNHDr5CVsuNCW/xcfRgxLpWFx
	 mNWAuqCIgeAlBg/WVI0u/CT24AqB+33esgT65JH8=
Message-ID: <6825b01a-3235-4e4f-90f8-9e75646bfd17@arm.com>
Date: Tue, 24 Nov 2026 10:08:41 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group
 assignment vs copy_process()
To: Reinette Chatre <reinette.chatre@intel.com>, kees@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, babu.moger@amd.com, fustini@kernel.org,
 jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
 <17fe3497-b887-4dc1-a8f8-3b647c1880a6@arm.com>
 <307b89b8-7613-46c2-a8a5-f6ecf7d05b25@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <307b89b8-7613-46c2-a8a5-f6ecf7d05b25@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B3DA40005
X-Stat-Signature: gxt8t4ic8xaeyggshbics6mn1uqx9ccm
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795514929-499191
X-HE-Meta: U2FsdGVkX1/yNyp8Wv7Bc4KzyPZfuEXFyLDClYt0y0KzmFtgtUvCbIEZi1iKwgwrKGZ/kK+xTla7QYJRaffEdzMity+J9rpkWIB216MWs+yT5p5j6zn1o0Ya7wVSEFOzkZfkoylz2fMAP9AyWakjcr7tXVBIAHh5Aga/ndaXmPD9wG3mMEroN2hVKO5AGOZYtBsMtq6SW10C9EoyQoxNC15CEcrvWy30mSzkIEnihG5c8MEKDOrqTBLeuOtpMl4/UB4ZcOZTnytvOGvpwd3zjeFoU6i69YAH9bUt4HHFVURv3xzKvfZn+0swZqrv07jgOWYFsCwOC8zcN29HfkhCpO5QUfcfW949o9ZKMP106eL0zmxuL97qAsNpLAl0QYrL3AsIrMErQc/RWjRVkYZrp96P61Z6WO0wsrhctjEhjRXnWDJLs8B/kjZfK5ZK6IcTv7hp5pRQav643WiEgu4ujeEmGS8ErfrOn9urm/TO+dcdBCB/RevQdEKwU79BVJZ8GMYrsq6vj2nOV1iCBCN0RU1Ffr57UlZhPv/3nuUdxcuZ7Ny8eCQC95Xavj13N9mPv3UwWMpdpnN1sbVTkjXO+MGp7GPo6MoI/LkKHAv53g2ZRdjjnfaQVHNuK8UYzC4QoiPU0we0XPnLK3SndZdCLwPeIrWKMchXp5i/AtQqfOHdaY+1SRIiMUzTRLMurt/y0n+BIb6c6V8AeWy7geHO33Xzlq+9aa+ZwkT5KBSyhTwx3l5ERn9up0gVYqLUK+nOhkbNmrEA+jeG2Ko6EeFEoPsjXNU5y/m3DFWlTVU1WHGQgLBQMBWI/boa3CMp9r/JHI4v4U4J1RpwGTODjVtQ5Yrdwyl0WGGqsxCSgip3vZBIAKIjDa3oCWFU5QjaJtNSB88ITCYZLzTOCCTZGDKaStIPqxWAKaDk+wM7VbQR0tjgJfzqeQChgfn97taAHHKPEiD1mZT3H2ax9OIsGzr
 2XhFv+Yi
 szjLp2UECD1w5W7XBgUozy5EGUW20Od9eNfEl+ogmT5EnGhvVSA8aUqH3VV6v6YR/zFu5ZC9U+cEde4AgG89cEvP6hBhIeVsuY1KrY5KnnYS0ZlWg24LRtvKsA9wDoKgfHf4g/wvNGqknjWT1lofOpF6WfOzsBqoY9k6HGLPX2pgNNiY+hrGW75LSxq5ZHHDBGWbdj7qZVDB/1M59VvBbfwzqxK2KYa18civImFFZdwO9XRIDcsEcNpcBBAAz0Swppgg2AdIA+7go8WkcA8YA9G/gyVv0r+PL1O5WjZk65r10hXAcVK5uqJzDNRUSE6IjnhKbVBGX2XVQB1IzkOjKfDH+JmLXZUWwE8t8wbGcSjcvUZNG253KMNfH5N1bBR7iJIPOu5okJHDCTTHZ8XxbW0uFQ6F52wEAciqNvYhzmIvCrecjMCIN+62vj96doYXnPMYj1p5jowuGRcYz4b4ZPyPbrAC8OleBz2iK6GRNc6UuegvEA86m3FZURTAMogRjYDwl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Reinette,

On 24/11/2026 00:43, Reinette Chatre wrote:
> Hi Ben,
> 
> Thank you very much for taking a look.
> 
> On 11/23/26 6:14 AM, Ben Horgan wrote:
>> On 20/11/2026 18:39, Reinette Chatre wrote:
>>>
>>> - A static inline in include/linux/arm_mpam.h, beside the
>>>   resctrl_arch_*() inlines already there. asm/mpam.h includes
>>>   linux/arm_mpam.h, so the reverse include would be circular and
>>
>> Hmm, the existing include of linux/arm_mpam.h appears to be unnecessary.
> 
> ah, I see. I can include a preparatory patch that removes it.
> 
>> As such, that include can be removed and resctrl_arch_copy_closid_rmid()
>> could be a static inline in include/linux/arm_mpam.h.
> 
> As a follow up, do you prefer include/linux/arm_mpam.h to contain the
> full implementation like below, which is the first access of mpam_partid_pmg
> outside arch/arm64/include/asm/mpam.h:
> 
> static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> 						 struct task_struct *src)
> {
> 	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
> }
> 
> or, do you prefer to contain all users of mpam_partid_pmg in
> arch/arm64/include/asm/mpam.h and thus instead implement solution as:

Yes. The second option looks best to me.

Thanks,

Ben

> 
> arch/arm64/include/asm/mpam.h:
> static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
> 					     struct task_struct *src)
> {
> 	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
> }
> 
> include/linux/arm_mpam.h:
> static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> 						 struct task_struct *src)
> {
> 	mpam_copy_task_partid_pmg(dst, src);
> }
> 
> Reinette


