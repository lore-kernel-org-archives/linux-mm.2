Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BE0CA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 04:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70FC6B0088; Sun, 11 Oct 2026 00:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9C56B008A; Sun, 11 Oct 2026 00:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C956B008C; Sun, 11 Oct 2026 00:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04F66B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:51:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C0D01406BA
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:51:21 +0000 (UTC)
X-FDA: 85309121562.03.8F5B95C
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A20040003
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:51:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WGwhXIQz;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791694278;
	b=Pb619K1y/cIzajNRr33BTxaxJD680kneElg9Vk8Bwv353U39LtMJtz+UNN3oByUug70hCZ
	cTXlgRxHD52Hrq4QbOXz9YYUPMYeIfgTe1IzCtyPjpYKy4yuugUjorFOea/x+mWfdYAnaI
	cSuNpnQPBPdT2Q4N7CP6cM4yW6q99Sk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WGwhXIQz;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791694278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gA2+L86nsB8kyRStDUPQMM7xvGJxQ8tS6sPNcinMsus=;
	b=yRI0u3NBkkybqkuuKyaAdIdekttP9LS5sZETuRu4w/HWeOsXa9AIZqt/wqw7n7NFVyrWqT
	EKAvOi/E3ly4rPM57QiEQ8hdbKyPgINSD8YX17NCt3FZrO93Xqo3kWAwMWRx/8PhFhyiST
	Ugg9j7AIDEz7w2+nIkpaUw9kASegO8U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791694273; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gA2+L86nsB8kyRStDUPQMM7xvGJxQ8tS6sPNcinMsus=;
 b=WGwhXIQzCIDydTUa1GADaUNCyhqy5h5oEkSJy6sBjuHEbLrEIZ1CGBE/smaFjZzr/uJXZj
 xwUZMiqm38as1Pqfevz9GlNG00BXKLxDmoITov0iIXwsipO8p2klR0Z7ySo+Mf5MZIDEBw
 Ja+DlD/5XKwwgjtY8ftIscsgC5LwUEzXLp1lm2Qm+iU4/keKLVeaexlsJyTvG35OmdzgNh
 YabKJ3OIYJhyZiNw/5tfjvXpe1FvsCgpX4jyyx7JrEi2HjhHMxWmH/+UTvtqoIzvsbXYeh
 /oVrVyGU0vLo+J/Sy+kJwSLA/+Rt5+rH7F8YgF0T6pdd3q3+g6WK6o2SrJTssA==
Cc: "kernel test robot" <yi1.lai@intel.com>, <oe-lkp@lists.linux.dev>, 
	<lkp@intel.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"David Hildenbrand" <david@kernel.org>, 
	"Hugh Dickins" <hughd@google.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	"Michal Hocko" <mhocko@kernel.org>, 
	"Muchun Song" <muchun.song@linux.dev>, 
	"Roman Gushchin" <roman.gushchin@linux.dev>, 
	"Shakeel Butt" <shakeel.butt@linux.dev>, 
	"Qinyun Tan" <qinyuntan@linux.alibaba.com>, <linux-mm@kvack.org>
Message-Id: <1ada59d3-446e-441d-8ce3-6e2ee46785f1@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
X-Lms-Return-Path: <lba+26acb15bf+7861b4+kvack.org+zhengqi.arch@bytedance.com>
Subject: Re: [linux-next:master] [mm] b9b1861d4f: WARNING:possible_circular_locking_dependency_detected
Date: Sun, 11 Oct 2026 12:50:51 +0800
References: <202610091403.d1d8080b-lkp@intel.com> <36a0604d-b0ff-4f14-9203-0ffb36e0917b@bytedance.com> <20261010161622.3a460fdbcd6765adb5c1eb7f@linux-foundation.org>
In-Reply-To: <20261010161622.3a460fdbcd6765adb5c1eb7f@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A20040003
X-Rspam-User: 
X-Stat-Signature: xqxxtcmps6q4u5gnpzrxp3p19ti8c8sg
X-HE-Tag: 1791694278-510943
X-HE-Meta: U2FsdGVkX1/v5Bl6vkPtdrDiD72Tb1Xd7mzb3XdJIfnaBPjt3xzew8o5CK6nGTubgfj7FDr421oxd25g8Yw/Y7boMKaT85T77E407A4IdBkw2T3lK1tst+5yCESmvyUyfZtXhZoh2S0aKkatND6RHWEVrK7nKBBQY61e9hYrvUgs2zsNyXziWxS8X5jo6+Wzyj43v4nUzhkC9c+jPG5cXP2GxMUCbg7RwBhAzbX/7+JYfAi5Gc5zop5eiHzriy9GmXen47u8aJ5cobTbPobAIteSNIBIzOcUHOq0E5ja3t0CI6e6BWzrEKoXdmkAePj7Gy7DkTKlamE2Sgj6Lks7CwqEcjWuk8GPh1cM5/MdFYiLRYOu2jofnLl7js6oD6zhTu5tpYwQcWrU7fQTiZXNvjkEJePxbeFWZCYu27ee+C3uRh4Tz+yMxFTiZJ6ht7fTVaCiDu6aJj2prdMaAXR1v6X4UzKrZbtHo0NR9vhhQBn7ssr3Twk9n0BrXRMy45gHoa+kSyY/smhvoq9ru61X0Lls+AS7PcnkQ8R96SsreYLKkK/UZgrKRzydKDwbzk7QS6mCG+IUi31sSy2jbF36TnyYH2IXM7BTpuxs1o6KxNsvf+uYPs6sHA1kGOjlyMbJX4Q2Wt2iQ7389yHhAO1BXOe5srR66zrkOF81GMjiXFbEWgA8tGMLUPR6aoWSKpX/aAeOVKFgi0kAk5GmXEztKy83VJd9na9gg5Ds2l0aKnxzsc24Cgcx/g8ZReAaVgPkRjw/fH2cIzXxDTZYH3GDpib3we1S/fqEtVD2cQ3sX3pQtEglsq0F4om7/F94rDqELR6/ke1WHOm8vgWTOE8e8Oofe3Pm41+nXWI1/RY23rbSEVF7O4wMVpzVHzqMbGa1nS6fW/zqXhdjMPiNRvnBvgFFqqjfXHtlTiMe1xOT1Wq4gQ/4AfR9hijTsEK9wYGcMO0FOpeKMKxFRRfL4F2
 YM/m9u2+
 nR+ON1dM2Ax5TdMG3rheqqVEgyIUdzMJzypZk0bMY1OmS9sOMyWxnGF8GlwuuvaMImtlOHRL08+idjfNDychowCBA5zeGLHtCq0DDEcPu2me2bRjy3tayF/pV7xyIe9FOoukwEbwC4yZklu9vLc+zKUuL76U0Lg3d9J0WpBNLHD+TYQndDMZMeshZP0qK3gzVklq11utWxLhvkU1XoGs4K4ssd9RN3JCDerqY3iOJd3tyZAma0j17QCU+wyVh13V06bxk/32qx72QMDnjXAa9DaFio7t0y9QgpOZurEra7WorJZDloHu8OiAJzIuLBty9pPEhOYNSNWbIeiVeV8Q8MofgGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 10/11/26 7:16 AM, Andrew Morton wrote:
> On Fri, 9 Oct 2026 15:58:46 +0800 "Qi Zheng" <zhengqi.arch@bytedance.com> wrote:
> 
>> Could you please help test whether the following change makes the
>> lockdep warning go away?
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 5a9bcc7c66926..8ee767dccc1f6 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5162,6 +5162,8 @@ static const struct dentry_operations
>> shmem_ci_dentry_ops = {
>>    };
>>    #endif
>>
>> +static struct lock_class_key shmem_unused_huge_lock_key;
>> +
> 
> This could be local to shmem_fill_super().
> 
> And inside #ifdef CONFIG_TRANSPARENT_HUGEPAGE somehow.

Got it. Will do.

> 
>>    static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>>    {
>>           struct shmem_options *ctx = fc->fs_private;
>> @@ -5243,7 +5245,8 @@ static int shmem_fill_super(struct super_block
>> *sb, struct fs_context *fc)
>>                   goto failed;
>>
>>    #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -       if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
>> +       if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
>> +                                   &shmem_unused_huge_lock_key))
>>                   goto failed;
>>    #endif
>>
> 
> Thanks, I'll await a formal (non-wordwrapped!) patch.

OK, I'll send a formal fix patch soon.

Thanks,
Qi

