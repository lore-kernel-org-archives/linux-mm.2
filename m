Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1853C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F4D6B0096; Wed, 16 Sep 2026 10:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30B46B0098; Wed, 16 Sep 2026 10:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B464C6B0099; Wed, 16 Sep 2026 10:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F94E6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:02:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 033341C142E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:02:50 +0000 (UTC)
X-FDA: 85219791342.25.100275A
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A4CA1C000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:02:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=C1p4+lMs;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567369;
	b=Iqo9w7POADdCxmgUyDZgM1McwHBrzkHWXB+dEHWS0YHdTj443y5PPiMDyEIeJAPQ66ME7Z
	7q+SQALJ2zNRBUKPn21a6m03rCP9JRil6j9tnw/Egm1aDrivKC6AVjK0HrbkKEiQCT0jK+
	ZgfVWT5fiFmoZ0qhRPfYedhZVB6mxhA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=C1p4+lMs;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QK04b22kulIc7bZXmZ0HJttAO0Z2ragkIvYz0XNFgzE=;
	b=hEx9NSa+BwV4Yx0CDYIvh1x5/u0I5O5RQMDyUsg1htc4H11GvhAQtgaI+VHIb1fSMiMGJ2
	WT/Sa2TTpWlM2Qb3phUCkUwW+a+sdVJA+GBHGez35FzCO+8gITMCtX+QWZmq7zytnU+gTs
	iPjHQSBz7FFCWkvip7xg8NdTABgDIVU=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93a0299c787so75294485a.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789567368; x=1790172168; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QK04b22kulIc7bZXmZ0HJttAO0Z2ragkIvYz0XNFgzE=;
        b=C1p4+lMsdaN3B+Z3fGBn3qkJVkgf4jwB9gr8NAEAjfK/x49Qy9MOCJ2sXHU6cGkxiX
         h5a1CqNAeBPXWHXKNk/toPSWtLuVSfenUjhJ18kgMytoDbLQhhp8aJxL+f2AmPZyyoel
         EkduKUqtS1F1NDa6/g1aKr6dGI6JTp9oewHGTIa1uM2y4CCj/aq1k3x4fdhawPrlBh5Y
         5plG8cW+fFZ2Ll2Te0J7P/TzlLautM1KDBU8+Wd4DtAl/s+XLCIGqE1zoRYa8XTsHxsB
         c5ZvgenvQJw38D8IL4T1OweclFZ4IuSw7Ox20fQkEwgspQhLgbB6pquOTk0A8ZGgvAbo
         188Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789567368; x=1790172168;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QK04b22kulIc7bZXmZ0HJttAO0Z2ragkIvYz0XNFgzE=;
        b=Vi/mLu9eU/hLVvVifJuqTqE9dAeeKNknkixl+X/NrQDCYA3ofB6lq5KTxn2ddctACA
         /cuIYJGTfvhoOPySvqNOtOHe9m7JP16rTS/oF8safoa4z9ACqshdqoBsaTqF0loJerd3
         RufVDloFpmcjfJtQKaICKLA3Hf4DzgVQaUNKSOlReYGCOsC3U2gn5cN60sy56ZR0p8xb
         d3QUKOlbKFGkalesjw1Dv/2XJODRTdMRiwBgkt/A9Fw/CyacLdEGjzDTmihEP4af6XG9
         wkTjttvy+j5FSGYdxlvFLpeYldkAaIDkpOB0DsmlfVFY0NLl79Cnxxet7AmLwVafgtws
         aSHw==
X-Gm-Message-State: AFuF++lkEFihVf9JPiTtpGOfGpm7gw0tdTamBcJnmXSib3nMHpDwefD4
	4lAZXfjQVbxsToU6Ulu7YKlbTwca6ZiENRyuFE5wgpGUwFBVX+iqvUJYo4qVzdtFhFo=
X-Gm-Gg: AYBFou3k7Giq/c6z7O012XPeIgUMKOyTBKBq6tMYgA4wnNLhclJieh6aqg6isHByypF
	a81ZEhKqELEqsZAICH6F80tenJ+q3R83pcb8T8Ox2BKVbTx5LHuK8GTJ0HSvE5hb6+zQGVvuhNJ
	MX+ysN1YI++eqt+06vmwBR6gllq8xqVYdJ0sKk5LidHEXE/Gd1kF0n/bNZU6sD1Nh0YXxbsPNmN
	Sep9pBKgUbqF7J5dmgUqDOneBOxN8ParDOx2/xY0PPLsd5pXcQKEQzXsSGRdtSGujEGBDs/ktW4
	BkeQtc7tADPYQEUZk7yXo+aIUm89X5T3SV99qtZ8QNupf/InzWMGfNOzgEknLPfOZRf4B/SbLQ8
	23N3uDQayogp3fPq/OcUWp5C38SsHNblsVP8i0ifB4xtg6P8QkyxBrR2bu4tSefjFjyQIE84l4c
	T7sl2hF6LhNXpJBQojM+q4NlrbCMNjA3s4jWmgD4+ve20Yyxp+I+AxGAIlN7q6TZl8rSs6Uevul
	HxKnS2PIUNCAfYLWKZHxaXP2e0Kjp6nmFb+apZzEsjdzrfqRmdL5mQ=
X-Received: by 2002:a05:620a:2704:b0:937:19d3:3fda with SMTP id af79cd13be357-93bb785c5b6mr477815485a.28.1789567368038;
        Wed, 16 Sep 2026 07:02:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b780cfa78sm218545285a.2.2026.09.16.07.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 07:02:47 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:02:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqgeOtYBcRdVqmI@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aqlzzwLOVT79Ti_7@gourry-fedora-PF4VCD3F>
 <aqqTtW3vjfzH8bcY@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqTtW3vjfzH8bcY@gremlin>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A4CA1C000F
X-Stat-Signature: e5fgc8w7gm8c1w1ic7k3ebifgdoux1wh
X-Rspam-User: 
X-HE-Tag: 1789567368-570102
X-HE-Meta: U2FsdGVkX19oK68yjEOfaFkSbZQNBevEV/wDV0YdYdAGiSAHhDmja8CfpuOa/HUKBIaSSI+W44XbHPkmCDnIOMQRKYbIdACSlGSqUTvN4PZ7UyBfYBJ1QCqwN2NdlemYCmKW2R4DbjPtNIJB5afsONGsWB4IMhyzdbM7L29UXZWSCQ+3on3MzkjoLra1YaIOH8IHeZFAJHPppCPerpPMBZdJsGS2A9nW9qMBoBzWIYu2dZzXs3Xvj9mkyHFDCGIO57cCeaZ8Ngfnp/1kHsAqOvW99Mmd7u7ihUZEVDL6MnLfDgfbRJ4ldtED5Ml6F0t1f90npHkiE66yJrYoJFs47g7/IlEM7ZeGapRDp35K32qX2khZ54XYtSod8c17NAaZIdlvW8edSG6KS/p0fk5oVqzaCiVExiYkEPgdTauevWsvQLcGoBCqBcq8vSyXEzl0xUWvq2wfi3wbTaCyyp+P3dQwCa1faKvN/Nkl+C/RU53alIucE0NaCPoxOZBuCO8tcwlos3l+hJo72G5eiWX5MnpOWWXXKPpXekfi9sabMri1GVts0to/sDQc1eHffbMjvvLVZ4bXJTGyaZ1xrQfaE/RYf1bdR4nE0HA3yWaO+MR6raodYJl1NE+HA3yKosF28w/ifsOnutMbCYabTua9JB4KY5GzVgbpJbkcHiyUx5OW9q4hH3tvuZvUExFLVvmrqAOOyj0cTmsVpGXekizM1e9jTeuGAYj03AuAwbfe9Sms84nyaTKPlERpb8EltnZW4ELKq7ZY0F0Fa7rqTNgG0XxkJcgJHKLquLXHq/sCl0wlrSWXHuD+nTTONT2tLS2YR95PStFYviYFu+afPdrE5JgciBvhWoR+XTJyA3BGBcZOu2X2l1QBufLz6D3lNoI5jZSDUXarMnBfgqU/mFv+6bqyKx4UVt5VhPBy1qP8f3P2J+ToLtib01BjERWyl5PH1hgsdcRr6P3X9qGol5m
 Gp0cSAx0
 GxZDChwFYIWnNp/hZtjuhy7fNYgCDOQCChjvpAqfPjw3DhcwudKCHHosxfr0aUT4ZvyG9Jxai6nx4abOIsybLKlBwv9Y+YC/I7Zcl85xvGDSjtrjIoiXCP4riDlulDBXyhs3ZCaYJrhpNF0dng+Uta/OjCc0x61sNSa2smMy2iC9acjK5Q7VFtevW3ndb+aSaCK77/dfLp0elNUZtcf3xXd5PNaMiNAOE7+b54U70YQA2bj6DS9XCex/X2RGmJQZ/Br9BT2b2D5Kxu4CrRx8GXBGykYWbCKtI3VpdU5OIXvW/HgbiTjewzZC/YEZc55A8z6xwlMgSZzT3OC9ZIBqr16fr93z/3tLqTIwuicO+itbsQkLg/zCyf0fsMhU8eJp7/hFiDDtkUKV9KT2zpe1M14YlQaRv3g8NNeKpNJbhurSbx2uQPn4FAiGOTISBOa4JQdoLAU24WIhzmqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 02:18:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > relevant meme: https://i.imgur.com/W0N40BK.png
> 
> Content not viewable in my region :'( seems I do not have a loicense for
> that!
> 

google "reading other people's code meme" and find the comic with 

// this is bridge

:]

> >
> > No argument here. This function in particular is really horrendous.
> >
> > I think i'm now 4 or 5 stacks deep on the "Thanks for fixing a bug, but
> > while reviewing your fix sashiko found yet another CVE-worthy bug".
> 
> Yeah, I WISH it wouldn't do that.
> 
> I mean it's helpful to some degree and it finds real stuff.
> 
> But it's _where_ it does that and the workload++ aspect of it.
>

In some senses - yes it's annoying.

In other senses, it's saved me a lot of pain debugging my new work, and
I'm willing to do some cleanup on the way to new functionality.

Someone's gotta be the janitor I guess.

> > I suppose reasonable to say the goto is worse.
> 
> Yeah I know it's all a bit much of a muchness, and obviously my suggestion
> _duplicates code_ which is also not wonderful.
> 
> But the control flow in the function I think is a bigger issue.
>
...
> > I'll spin a v2.
> 
> Thanks!
>

Given i already started rewriting and validating the entire garbage
pile (see other response), mind if i just leave this as-is?  This gets
completely replaced anyway and i'd rather not have to go backward at
this point.

~Gregory

