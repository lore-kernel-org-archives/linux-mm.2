Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626C4C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4BF6B008C; Fri,  1 Aug 2025 07:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74446B0093; Fri,  1 Aug 2025 07:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C890D6B0095; Fri,  1 Aug 2025 07:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B817A6B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:35:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 592FD1A0519
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:35:46 +0000 (UTC)
X-FDA: 83727983892.08.850AB8B
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id 486CB1C000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:35:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754048144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dfKkX+zdUN0aVP2TeHwJjEVN6pyefEeMUl6EdvIBgV8=;
	b=igWcKdUhzaUrVg01pq43fLWC2tuGtrlr8W5GmOFQZbHL2S6Ci50dZQSelJMIXqMHsVd+0W
	dEH6XFwGf2jTmSG4aoBGIHq62FcoFSm9LpfPIne8i64VaQFr7w9WSr0aPJekpRDlrHLJs2
	zkXg1Vdrc9nt0vHk6ryxgTcN16ht4+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754048144; a=rsa-sha256;
	cv=none;
	b=y+ZIjSXSt0i7V2G8yWBhpxu9g2I2a+1WvflIz467FrKAdnx3epLaEby+1PRBlqOQC266li
	NZxlVZmYG1cTwd+7dHdNyCwE5MBIfY50sN/TYzvub200XNmaouNduxn1gGB32qTCyeNho/
	8n0cx7NBHEAiV5VHpz+dYf6sfMbCIfo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
X-AuditID: a67dfc5b-669ff7000002311f-d1-688ca68a1765
Message-ID: <679e90f5-cbeb-4078-ad76-a075fa5d7afa@sk.com>
Date: Fri, 1 Aug 2025 20:35:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Content-Language: ko
To: SeongJae Park <sj@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
References: <20250731175827.16060-1-sj@kernel.org>
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250731175827.16060-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsXC9ZZnkW73sp4Mg6NsFk/+/2a1OPEiweLe
	mv+sFoe/vmFyYPHYOesuu8emVZ1sHps+TWL3eLF5JmMASxSXTUpqTmZZapG+XQJXRtunLWwF
	75Qrjs2fw9bAeEami5GTQ0LARGLesXY2GHvtxL+sIDavgKXEm7YmFhCbRUBF4sj1V0wQcUGJ
	kzOfgMVFBeQl7t+awQ5iMwu4SVy9fg/MFhbwlNj96BMTRFxEYnZnGzOILQIUv75lPtguIQEj
	iVNr/jKC2GwCahJXXk4Cq+cUMJaY/PwEC0SvmUTX1i5GCFteYvvbOUBzuIDunMImsfPLDXaI
	oyUlDq64wTKBUXAWkvtmIdk9C8msWUhmLWBkWcUolJlXlpuYmWOil1GZl1mhl5yfu4kRGOTL
	av9E72D8dCH4EKMAB6MSD6/Awu4MIdbEsuLK3EOMEhzMSiK857qAQrwpiZVVqUX58UWlOanF
	hxilOViUxHmNvpWnCAmkJ5akZqemFqQWwWSZODilGhhFWE9JF9s5nNT5vf/JqplqFZfMNzF2
	BEc13DCPb66wdn7/03T7z2jGnXzPOuxnLZ53JWTVjYnrLwpVBKafVllvuoMvziCqd829qdGx
	1eHbWorfCt/sX+gSqTyBQ+xd0OPJPGezw8OnWjBaJenGG/OIvnlUMyEhasZl+zOTTh8UZZjc
	/1ZOWlmJpTgj0VCLuag4EQC+EQ+TbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsXCNUNLT7drWU+GwcEGfYsn/3+zWpx4kWBx
	eO5JVot7a/6zWhz++obJgdVj56y77B6bVnWyeWz6NInd48XmmYwei198YApgjeKySUnNySxL
	LdK3S+DKaPu0ha3gnXLFsflz2BoYz8h0MXJySAiYSKyd+JcVxOYVsJR409bEAmKzCKhIHLn+
	igkiLihxcuYTsLiogLzE/Vsz2EFsZgE3iavX74HZwgKeErsffWKCiItIzO5sYwaxRYDi17fM
	ZwOxhQSMJE6t+csIYrMJqElceTkJrJ5TwFhi8vMTLBC9ZhJdW7sYIWx5ie1v5zBPYOSbheSM
	WUhWzELSMgtJywJGllWMIpl5ZbmJmTmmesXZGZV5mRV6yfm5mxiBQbus9s/EHYxfLrsfYhTg
	YFTi4RVY2J0hxJpYVlyZe4hRgoNZSYT3XBdQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9XeGqC
	kEB6YklqdmpqQWoRTJaJg1OqgTHQIm5bh78L193qOXeLJTK9vO/8rXPPXFbh28otsMzb+w3b
	62TpXaX/N1pOkYw9Yn/KaqrKbJlObZEdl2649ty8mP2Qf96kDVYGZU5/s464lPxN15963S1c
	fOdX+eatDXJrnnVbveaSCd/4l+9W0pZ5582+GniwmmbXd3U4/muRCSzaPcvxnBJLcUaioRZz
	UXEiAGrw5dBWAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 486CB1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pqmq4d1y1yingitn567fxs6emzaxkuyq
X-HE-Tag: 1754048142-738886
X-HE-Meta: U2FsdGVkX1+my5GRtNyqdQWnZAeejcN7ysYkFcZlS6pSybWXENixIt82HSnKdRuTnVm1/b8xbNinvEVDheHLhrnSfN5P/ItkZDyvF8MmwWOAkHOHMONgoxvK4+uPZx5mgUmT7EExYIFVb5JFVdFFl5Y2lmULYogqZduKBTnx2/vc49uQ6p8XBkDtBfigC6nRGRMucgiKAFlhyYLxgdJfPTJBw5Y36wDIlzKU+XzyjoRqknrbtte1d5mlmL/dePRQ6KVxRz3/N3yM7dYORth7EhlckxlW8NTt7q/Kd7Dga+JwkHT1F/kzYgAvh8o2pzmzG+QuyUbrh1ND2iMrggTaL0wXMWn4zrBVL/2Y0Hiya0UOLNNOL3fVsGYseZq8m+b2kR2BDAx3JAw87fAkgcApqihtEEHewlg/iwrJGJBJnDmZknH09yCBI8GLKylM2sLgFVajaU/fN4Bw5vDeFjJ+tae74kN1ociA9nKxLC8VCv1AMGiKnMJX1dnGpQ5C9qjxxpE5eenVx3G4a3qcU5X0lUiCfVNwrDerr5yvQpaKYKfhc2XhHmODWmk20xzoZdV7IbHh5BCCjnSFQAG4OBi/a4MQ6eFdpG6aojMXUvdw4aer6cHXsnSDYInbFdfwE0ScVVzXZK+m1vblvcU3QiGiSXB32UoaGoyVebuoapjoZEFBkovuEURNub5oDRkVl3X6twoiVxk5cgFUBlRNS/7mb4UiZp+h+QmXwdGD8Qh+yjlyPgm/PNLCbiqnhrk8gBfyOEFPo3/KOjlP+YqsrQYlncZBYldk5NIp2YqSW4Eighw5ezqY8jEb3acq7JZlBWSrbuwsEJe4eQg84Ymzpg3EXsSCWNSm9gZdjXv+cbPU0TZOQ+1eujnU138H78kVfaGB8uriQeh82rfvFSutpmxQsYXkXMBCwLaBe4p4cfbGtFjbI46Nxu2EHkXqEjstZe0xuL6VyQiVi8H4FoxDKbq
 sQLg91wo
 tei8y6rQTHtw6smUIceNU9IRoO/vNW8nEm0e3gXhI2ZK8/UaS93fD8IIObxA0d3fwUvn1ui+i+5JMFyQGaAcOfgYdAKAlMs5acmAdG/7T7ADKOlu7oMj7Ldi+kv1rUVuRLZp6daHsgnmKxSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sang-Heon and SeongJae,

On 8/1/2025 2:58 AM, SeongJae Park wrote:
> Hello Sang-Heon,
> 
> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
>> Nowadays, damos operation actions support more various operation set.
>> But comments(also, generated documentation) doesn't updated.
>> So, fix the comments with current support status.
> 
> Thank you for catching this and fixing!
> 
>>
>> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>> ---
>> I also found below patch(https://lore.kernel.org/damon/20250730200239.60984-1-sj@kernel.org/T/#t)
>> So, Is it means that DAMOS_STAT is only supported by paddr now?
> 
> No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT support
> on vaddr, but extending the support for DAMOS filters.
> 
> Thank you for checking the thread and asking this question, though.  I see this
> as an important signal of another rooms to improve on the documentation.
> 
>> If my understanding is correct, then we need to fix Design documentation
>> and comments both.
>>
>> However, since it will be fixed soon. Keeping current status is also
>> affordable. So could you check this point as well?
>>
>> ---
>>
>>   include/linux/damon.h | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index cddf82eaac4e..0870e9f48b0f 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -128,7 +128,7 @@ struct damon_access_report {
> 
> Seems you are using damon/next as your baseline.  If there is no real
> dependencies to damon/next, please use mm-new as your baseline.  For more
> contexts about that, please refer to the DAMON maintainer-profile[1].
> 
>>    *
>>    * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLNEED.
>>    * @DAMOS_COLD:              Call ``madvise()`` for the region with MADV_COLD.
>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEOUT.
>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> 
> Nice!

But doesn't it make confusion about whether this pages out to disk or does
demotion to the lower tier memory?  It's because PAGEOUT action doesn't do
demotion, but it looks "reclaim" includes pageout and demotion together in my
understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.

Thanks,
Honggyu

>>    * @DAMOS_HUGEPAGE:  Call ``madvise()`` for the region with MADV_HUGEPAGE.
>>    * @DAMOS_NOHUGEPAGE:        Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>>    * @DAMOS_LRU_PRIO:  Prioritize the region on its LRU lists.
>> @@ -146,8 +146,8 @@ struct damon_access_report {
>>    * The support of each action is up to running &struct damon_operations.
>>    * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
>>    * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
>> - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
>> - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
>> + * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
>> + * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.
> 
> Thank you for updating this!
> 
> But, now I find this place is having outdated information that partially
> duplicated with the DAMON design document[2].  I think the design document is
> better to maintain this kind of details.  What about keeping the high level
> information but giving a reference to the documentation for details, for
> example, like below?
> 
>      @@ -143,11 +143,9 @@ struct damon_access_report {
>        * @DAMOS_STAT:                Do nothing but count the stat.
>        * @NR_DAMOS_ACTIONS:  Total number of DAMOS actions
>        *
>      - * The support of each action is up to running &struct damon_operations.
>      - * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
>      - * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
>      - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
>      - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
>      + * The support of each action is up to running &struct damon_operations.  Refer
>      + * to 'Operation Action' section of Documentation/mm/damon/design.rst for
>      + * status of the supports.
>        */
> 
> Thanks,
> SJ
> 
> 
> [1] https://origin.kernel.org/doc/html/next/mm/damon/maintainer-profile.html#scm-trees
> [2] https://origin.kernel.org/doc/html/next/mm/damon/design.html#operation-action


