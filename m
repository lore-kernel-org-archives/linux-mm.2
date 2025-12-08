Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB767CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 04:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597C26B0005; Sun,  7 Dec 2025 23:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5487E6B0007; Sun,  7 Dec 2025 23:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E6C6B0008; Sun,  7 Dec 2025 23:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 394DA6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 23:01:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE21C5BC6E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:01:17 +0000 (UTC)
X-FDA: 84194953794.10.C0F09A5
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0BF2020007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:01:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bKzcjPjP;
	spf=pass (imf03.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765166476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/1ob/kLkc71l/BDdSnNsSLL33QQ6a4e2+EPIygILiM=;
	b=tM4E3NwbT11xQDkL2TMCjd/XdN6h7n52QMs288VXqmVWYDbKstBb0R5kExOYnPQHf0IhpH
	1LVzoU/0piksHgM+xKk/k2F3ch38YkeKGNSIcMFZr841ne3oR/lWFiMG/4kb4iCRMrTSAj
	u8fZwGbpiq0iPOnTd1k/kOl0rLiuIyY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bKzcjPjP;
	spf=pass (imf03.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765166476; a=rsa-sha256;
	cv=none;
	b=zZui74+taLV6VYJcBYCRykilJ0b+X7N7OStDIP55AImb/abaJYdc//Hu9BFVkdcrRhqQ1B
	BtgsvrJq4m0Zs6jZoikHTEVPsPPtIzAokK799706Q7d07y8iEl5iVuBMNVtWJ3ijEt0Vhy
	XY9xtLuZok7EsTQhS0/bBjGWhCkUjVA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765166471; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p/1ob/kLkc71l/BDdSnNsSLL33QQ6a4e2+EPIygILiM=;
	b=bKzcjPjPLHd08oEgF5RD04ligoxr5xIzBJvdgqZxBMg+V884XuFAExlusK0EN3P4gLqVUoOdDVM3e3nw0N/0XRlw/P4X6bx51FIajttnfYWi8/n+KuiLYL3ulf5XcLdIzuctvUo7+LVVOPT1Uo2KnncDPWJ+/NeErAWnAwd9ss4=
Received: from 30.221.145.74(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuFMMVn_1765166469 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Dec 2025 12:01:10 +0800
Message-ID: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
Date: Mon, 8 Dec 2025 12:01:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Linus Torvalds <torvalds@linuxfoundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
 <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gktx8oqr4jfg6dtn3stq1i7xspc1hr7t
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BF2020007
X-HE-Tag: 1765166474-118283
X-HE-Meta: U2FsdGVkX19mGxonOwy/SRj9Kvj4IVJ80cvbMrPyK4ebHWOEpQ9nPisKkSlx65pwCjVWdsIEpzbGQWgaEeU7S5NBU899QXzcxgpGrod4npX6Ho833EQUW5GtziuCQGcBFYwOFlr9TH66hxCqF53ejbIV9osN2BryL6RUwoZNL+o1A2G0/OkSlSL3qKxNSw6zoOBQBIeRr3vIAN5Wn56VIA9/UooH75cYL+Z6uhoVNFGlbcSyYaYyms5asT9vx1xjSBciJl6gLX2CL/AdBybi6Fv0VuW+2WReYU42ZSbNKUkLMc/tC+WGBMjzCCIcLDFoTU1MpfYNhf8hs9p4P1zoaNP02H1C8B+elkinnZKEUZ76wuUaTuekyMrNWWh0qmS6+SKA6kypiEnYVRkJd/GlcuVle0oKDXnvS+FaF6FkDRCIB2yZdJZuOk9e9XNGlgIm74xSEoH+7voIgf1sz2AJWqj61h3UjEOW3T4tzUEap77hcaSRTVc8hpwYyE4Eu7Z4Nh3JwhWBbKi2SMBl8J0SSYNIXH6DqbICKxynUKvUhC3xTSBWmPq4ogKqAs6EAqzo87pinH3Sn4+vHKk7ocpDxnDoVTvHdGEDdrTprlGjquJ1AEWlJx5qXB7EkUxEneDFdekM/bV9J0fr5uBgfz8l8x/jR5QfriaD0LssyB5F4ErH7XlpX2w0zk/0usK+6lzJy6nc+uGMtqtBClUd4HeZHGMMwKne0TGhSzSkPtsnkrm+JQGS8k4asQEVeHBp9x4TseBv56ll+DiQSJ6JtvNFITKNMeR+nm8jk99J35tjk+qZixiIdGnTelE4/5boBnweeYCJnNxk8zPBOzLHjOL4UfOhGuBzSdE0s+hfjTXah5uNAnIdzt1bdxyMcNlOYCBTA2YoPMTZAQo2lUFQpfxKK6wblNfxSUdt01jFsR76zRD40yTgVSwvZ0MQNFSxgqzrviz/6uCIOc+BoQMcoys
 NiBNluoP
 bsHVdTD5IHOzDGPTe6k72ntW+dvs86ZWXhQOlOJb2DHl6HeAOSgKCRcf69rL7dYgeA7+vacC7P8DH/I2+ojlveNBgdRohdg6lxlSJ3u+VrAhAkJziBjmKiwtbaNnj3kpowdHIEFIUyijMRiwHgj/hU9bumwv0J0ZOwbAk3saUL7MoW6+BqbeuvWqpzAR67cnhx2ig6VkcciXSEF6fKZhbaJpTAHrXMGlL6incniB2363wFUJdEEfm/LHi+78cz01imUkea8/xG4UkuBejGVgyqNqDxVlnB8dHUcKOiq0ayUGIyZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/8 10:21, Linus Torvalds wrote:
> On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>>
>> On 2025/12/7 07:40, Linus Torvalds wrote:
>>>
>>> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
>>> error") which simply makes the 'last' pointer point to the actual last
>>> entry, rather than point to one _past_ the last entry.
>>
>> It looks fine to me.
>> Sorry for the noise and thank you for pointing out my mistake.
> 
> Note that if my fix is correct, the mistake is most certainly not
> yours and goes all the way back to 2009, and commit 0fe9b66c65f3
> ("ocfs2: Add preserve to reflink").
> 
> But I would really love to have somebody who knows that code go
> through it, and see if my fix actually is the right thing to do.
> 

Go through the code logic again, maybe I'm wrong before.

Take the following flow for example:

ocfs2_reflink_xattr_in_block
  ocfs2_create_empty_xattr_block
    ocfs2_create_xattr_block
      memset(xblk, 0, inode->i_sb->s_blocksize);
  ocfs2_reflink_xattr_block
    ocfs2_reflink_xattr_header

It seems now new_xh->xh_count is 0. That's means, it is trying to add a
new entry and here 'last' is pointing the next free entry.
If so, the original code seems right.

Heming, could you please verify this? I'm not familiar with this logic...

Thanks,
Joseph

