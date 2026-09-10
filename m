Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F72AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633706B008C; Thu, 10 Sep 2026 02:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C696B0092; Thu, 10 Sep 2026 02:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D096B0093; Thu, 10 Sep 2026 02:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38B4A6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:48:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0928BC041F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:48:36 +0000 (UTC)
X-FDA: 85196924232.21.CA1CD30
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB13014000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:48:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W8/NzpWV";
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdbujpu4aOo0T4Gyax2Ea3UO60X2jGQ9aFI7VTtnyXU=;
	b=bYBiqzRwLeMOy9iVhp20hPBdbrv3HOrmqA3+1oJsfk5t3ig43PHRkfRFNeXHn6ncYqjB0A
	uZFdthGUnFcRjk3AkC/T65H1nBGVnYNVLZgfjFQG6RYHN+96PxROboeRCVdu8ElQThVShM
	FkvdOUauJmR+2Vzg/3lPoGIX6B0BthA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W8/NzpWV";
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022914;
	b=1DQG9lAS8OAyxCx0NjXcAhghxwmcAhyPh/PJLw6TIhuudO0kyYZi66oMgpJMM1GVw+NRzZ
	7VTSsgS1rxmjfK5j6oxHDhZiPqpnLaUuPRfp+coJrqWJkLTd8q28RuIF1jLhayAqyPcj7+
	ySPk3BPR3KXdDMK6OxKPTLR+lpWnnyw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YHacq/CRvcLogvUw1Z/iF5AmWhyhaW1ODj1zgiJ2k7E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789022910; v=1; x=1789627710;
 b=W8/NzpWVVXERmI5NSrKpWItFXtN/X+flt4m4J/PVB1v3gCT24ku4gX7V4pAviM6gktup4Y5c
 h6ByV4vdw5PdjhRRk6RCOp2jvp6LInuYR9h2YyTBk0iAP+jL4tGwNZ8HLT3qjE34u5DtZAUzaIe
 7s0QQUbnrI9i+o046EGpK6sg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e82ef4c2d92f9736;
	Thu, 10 Sep 2026 06:48:30 +0000
X-Mizu-Trace-ID: e82ef4c2d92f9736
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 00/11] mm: Switch device DAX to section-based vmemmap
 optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260908184516.c026438445ff3db78ee120fa@linux-foundation.org>
Date: Thu, 10 Sep 2026 14:48:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D743D6A9-2D4A-4708-9099-AE29613CC3BF@linux.dev>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908184516.c026438445ff3db78ee120fa@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: xh5t8o3dmwgkhd9318aco5hr71mnyah8
X-Rspamd-Queue-Id: BB13014000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789022911-978445
X-HE-Meta: U2FsdGVkX19WvNQZlW317F7gX8PuFEqKg0p/3+EJoy46xYUcSvaSkTksmb7+6XjQhcwcJwwAsUwRc8NHasc6bsnvrAaKfDTSjWr6AnhmepIy8J04F9yjUk0PhnxvaLboK2wbZuCII6ldoFC0Dxbd7kbSBD47UsvejIjFhPmpR56HEZ+j2TDRjkVFsfplaMdBEv5ks66p3T8oKHd+2ql94WuiE2RVTYPgCD0OVjiL39ahV4NJ74yVURO8SmbDUt8aIdRP5V47LPilMfCsj33rGAEKaiwECQip9sOWS6Xe7n54CcFIYpapH//p9J8Z9dGqEle4GMmtF2v5gF7qUax3yhJvrdduonpmTTWCQRoJE3ohMlNDbTBAt7LRNn+ERP16OAkBgBMb1FsLu+Q2n2NzvvNV/5GKnQAveRrwmZ7aSrg2qjIpaIoxQfh7TyeMP6nwA6LyOvZoR94JW8Uzbdr8yUrudiT/adM/OKlFB0cgfgS7/LXzf7keEoY2GEWjFWiCpIFxlBq58Wwf9s6NBoxoutH+UiDR0efB+ajH22yxRzPVLhCCQU8m+4BWpZJzsljHJgUScyuX6/Wx/UyPwNM6tzUgXt9rVhfz5g9GVFkzR1tP2eHpiqUMLoRi+50uJnH8ZmnnvT0YKeccmkCETkRPI82cqwWfCKdJc++pOhvlAP3+hIvtjWIPdDjaYIjrR4RWw0UAWwLOiuCu4/xWilofSGjIT5T8BnK1bfIfLoO4rbxz+C867D5dTe/53KO4yyPPO16D3VaoN0YYi83oO6s5mVo5gudq2vnE8cLrOtJqmEl/B2Jpr+QwJWDgkTudJQmDuCOhnVjEoQptj1wkHJfYOXArQi4GCN7QyA2UIMFZfeejQtPMPp6ZEX2t3C7dK3wh55MqlOTnZ8exQuUaEyBIMqTq6Cnb7BvUzxgMwvzf4G5FEWm8farTrgni6OYBkB7l69F2fDROpRNS9NfHs5s
 FGRy6mEF
 gtVsE2Wv7/XnCu2WLf0ecA/XmvJ3AhdRAOiCzR2SuAg1S4AFIo7lR7c6VRUsCL22Ff4eproGTwjzaQkvljaPSmy4iE5/lMEN4CB4o3DQQTo3yu0dy2NDMkOxm1c2zSiKJJosZ2w7H5z7jwiDmQDGewCDVy6ozO4uaTrH65Ah6Zqwn+Hy6fSCcEI8YU0lZ7sbdEX09wv8NHjScXGnqfjPmtbJglikAe55mJ6HTpTUVAG7z1VqWiB6xFpKE4DEa+36r3/lO8UdsfGhd8c5Cv1ijudeLOo7pi8Mrj4FeANR6ewBGcsrNHoFTbZp2HgdTmhL08BYZyTJpCU7icFlB3cowXnObX5hFXJ+YzXNPoNKkIs5YzpWDXqndLk8/1AWmQQyCYqJNOfsjIc4nx04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 09:45, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue,  8 Sep 2026 11:03:24 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> This series is split out from the earlier, larger series "mm: =
Generalize
>> HVO for HugeTLB and device DAX" [1]. While the parent series =
generalizes
>> vmemmap optimization across HugeTLB and device DAX, this subset =
addresses
>> a single, self-contained step: switching device DAX to the =
section-based
>> sparse-vmemmap optimization infrastructure introduced for HugeTLB.
>>=20
>> ...
>>=20
>> This is intended to be the third smaller step toward the broader HVO
>> generalization. The wider HVO consolidation between HugeTLB and =
device
>> DAX is left for follow-up series.
>=20
> Thanks both, I'll add it to mm.git's mm-new branch.

Hi Andrew,

I've updated series [1] to v6 to address David's review comments from
yesterday. Since the current series depends on this v6 version, I =
suggest
dropping these two series from mm-new. Once the v6 version of the =
dependent
series is merged in, I will re-update the current series to v3 based on =
the
new mm-new branch, and also fix the compilation error under !CONFIG_NUMA =
[2]
in that version.

[1] =
https://lore.kernel.org/all/20260910063256.64386-1-songmuchun@bytedance.co=
m/
[2] https://lore.kernel.org/all/202609100517.0DrzxrW4-lkp@intel.com/

Thanks,
Muchun


