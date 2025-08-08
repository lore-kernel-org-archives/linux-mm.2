Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A267BC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFAB6B0098; Fri,  8 Aug 2025 10:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297686B009A; Fri,  8 Aug 2025 10:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185C26B009B; Fri,  8 Aug 2025 10:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 091DD6B0098
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:16:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDD59B78C6
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:16:09 +0000 (UTC)
X-FDA: 83753789658.20.BF426EF
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 846091A000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:16:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="T1xv/Fl7";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754662567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG/jc3uK17nl75KdjjSPz9XyI79UN0Loip6e0tTXadc=;
	b=Bb2FWr9uH6p/ya1u3Vw1mV5Ekzo16mS7miEPp2Fh08JzUOst/CukfR5t55E3Vt6JxIiAMw
	il/TLksBxHgiAAA8nTFj4HdbyXAkOml8aL8Rb36tVLZRdoygJDIgCHu9FqUPfMu8bcsMar
	FCpKqOnm5Bg/XX6sG1Ku5uCkhdCk9e0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754662567; a=rsa-sha256;
	cv=none;
	b=kE8xBa49hu79/ybDxDKcuDCP6RFM6kgsx5XMZ+akXEdhOclsdcEDmMW+fkweV3FOj7uTfg
	v07FWTthvLctSTOKYk23LDAgtsmR7703z2F1oeL9Vtq++kH9dxiuc3bJztiTl1vy2aeqfa
	aiIKUOQewJ8AarVluAHGMNxkKgmJsf4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="T1xv/Fl7";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b78315ff04so1807110f8f.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 07:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754662566; x=1755267366; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VG/jc3uK17nl75KdjjSPz9XyI79UN0Loip6e0tTXadc=;
        b=T1xv/Fl7P9XN2bQuGO4bBI06jtpgUx9sIKqUxRNMLd7JdmrVW8ONCjrcETjVY1CuUP
         +LPQaepk3vvJIpxW/hPkeMr0Snwk0reLMt+c0fBYRUm4jtmadMpPKFa/iT5yL1tYGMe0
         HLm5gc1fX+2s7zlzn3D1EP6vlHXD8DbVPRC6J7Yx0Wo+3HV/cxPDMFS5N74bEMGA8r8D
         O1SKuGBd/FZDzIrm+MMfrk16oGC4Vuwz4rYNyFPKUDor7jeoXyeR2Smvq5gA2ZfCK8jH
         F5a/KI4aCaH0dpLTM0Pa2gwSECcuiemFqHSX7XVVFTW86xfLAEh3JadeS2tTOLpCC6DK
         S2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754662566; x=1755267366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VG/jc3uK17nl75KdjjSPz9XyI79UN0Loip6e0tTXadc=;
        b=nv493jwqgIHRAmUYi2c95uJmy7DXCAo8cLAklJ/ceYVoxLAmXux9USt8XrU0z0rpCn
         SR1pKbwfg25HL12zhJAkkwZ33mJNxXuy4QC0MYlKIxdssysubLLk4aXrNw8JLlzpjCji
         HGf4h97gMYJ7EP4rU0OiJso3x4U+Xfn3x4b+U5/Qo+Mqm+4yj05t/FDZ6PKDfdxYiLH0
         2UqKqUdWn3YpvS034R/H5VWBQcwAmMQ7GRvIWnQ2N5kK1KMqUSs2NXBANWwL2Wcz2D+9
         MbINh/ZRm0qlsTVR3zI0eIk9ndC9WSHcqyi4XXxxsiTpZr6tzt8ctF/YdA4jykD6S0lo
         JpQQ==
X-Gm-Message-State: AOJu0Yx8SuYsXh4hM4xZKFwv5hChGgU8aq3GixbxKl0O4l+JFy1NvgU9
	YnUD2i2PJbK0gVniiv46kHyUKH4HaY+6iVPlpgZ6WQG4nwbUftfClhGojVb0GWAo1Ko=
X-Gm-Gg: ASbGnct9bfJ/rYhECAXRTAa9edwTxw0UhndE4TOTlSGbA3dOhL/om0Ngivobgrcv5Sf
	l5o60VQaVuA1WmNW+jyjTwjNcK07cONpcbo8w+hp60qDa6Yrrgle1CPb+heSG+pd9P2T0TRk66W
	YB7CckvNsaIrVPlurd3E8SXnNGMjCSLdiPo8/TZ/7iX5yMXeM7rQDQvON6AH3JZCLG0+8FMBq+U
	kBYwQgLRZ+b6hnHmgCri72R6LEMlKirZnmVO7Tn9znfuekUDvEdNYSMeunOPxKHEsFQfAh8uz2J
	SWhYhzttwcWfRt/FtgRTrAVm5SEx4dCkOLYAbdkF1IjwR53fQkoK4xFYtzuWIKZo4WP6Z57UYxl
	CQg2dDENj3g0Ii0OI+mhUrK9h2g+R+pm4u8I=
X-Google-Smtp-Source: AGHT+IGxfeBVNh4/aUszACoEq3XC4D6RxS7RyhP9MWdnuW1tiNhead0J00S+ncEYW0u2MGjwZKQcBQ==
X-Received: by 2002:a05:6000:188e:b0:3b8:d271:cdc5 with SMTP id ffacd0b85a97d-3b900b72d90mr2675104f8f.34.1754662565959;
        Fri, 08 Aug 2025 07:16:05 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3ad803sm30258751f8f.6.2025.08.08.07.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 07:16:05 -0700 (PDT)
Date: Fri, 8 Aug 2025 16:16:04 +0200
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is
 set
Message-ID: <aJYGpPoaZwYZZ3Ze@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-9-urezki@gmail.com>
 <aJSU3O-pUnTnl_wP@tiehlicka>
 <aJX3zbr8QsIs1LOw@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJX3zbr8QsIs1LOw@pc636>
X-Rspamd-Queue-Id: 846091A000C
X-Stat-Signature: hnds4rzbw4f6n1hs1d98zmdn737stgp6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754662567-409163
X-HE-Meta: U2FsdGVkX1/GUrmhnNUO614O5SwOE3YPPwdDzmO4qIIWpW+vBZFoaN0JGChQT2LBTqHItZV7TKmvUPZMGAUMTi7VsLAJsuP8ocfTqUd9PKLbLEGnAXuN+IJhQrT/p+JoNsoDVoGq0PwsiEPXrwqLVBgG/JiYwUxNAHvVx205ho66kZBAeuoj4a9G7IZhvD3BPpQfHmCu6zaySGOMUJKR4DBoxJHjh+nxrtdKlm37opBitUaHOoTghxtj9FfqIya7Sfi8+dvkrlxWun1wSYoLC2g4j5GJfj1mMsPrnrBm/OPyDa5w2j2MGEx3b32C3Pi54av3KI9RowemeNcpURI91fMP9vPjfPnqjLSZqyATiTyfWyPPE9wOa0WZAZ+nq8yk0+0h+nyoXa0Gx7UyLk6m/M6YaexAQ7ovKwHzMZQTDvOV/pWm7sJr19WlSGUstw0ss4k8wmmUo8S54d7l+OnbuQ67bH+gQbi/dqrFEaMvwOZEN9qfFquVEz3yolttPHyQ58BpQqcejiDqh0RujoTkRBd3rRXZyoGJC3nALQwUxTUdeNTVPMgw0nJn1RJHDot8BQ/lTkNQl6ybc03P/pIFidumddoq4duKkK69D5otP7k8NRwPRRphKLyl+K8pz48nUijWuY0QnWJdIJUHSfeWVzShyqL8hXq7LmK7CjnBheGquSpsjlsZsGL3mHMGTPCMNiIVx9q1XfmGHxB53lBSUuMAAMnnMJzp65IujCmYv0PxPhu1AzPGuPmL7KMSi+QNU+xLM8ff2sKSGKTwCl5xTGtb0bQnVcZKmjBG3RLoPZSQpKP3ijiG+IyqHgtoC3L0z36Y7ijFuDMMBocU6slX4siv5X6Z3RM5KILpMqgP5ENM1HP0BdZ0m83NIMeCl5UXJ3UgAcNKfO0/D5QRqePaLTpuP8svgoHGZLlFZk1gq8diKwTR9RctAvGGc8Vm4QT3gCSlkKQbg2xA1U2yNGW
 TKArBBlL
 s3T4/kanfzW0QPHkFgKpGJW6ZryKgfu4pw2ynQRoc3fp4c8I6wN8j2prJYnoyUO60BQEOSJkjZJf0HQCUtk+IPytOAFGStUPEhetif1lp5qTR9Mj2JQc/t6+VqrQ7sytMjDO4Lm8Lsmt/U2lulEjK+O3oeCZhynaQFJpq9MqHOnr9XdZLVq+9T+XG7CbuvyoYUT0bwI2EzQtLRJJKKOhenS7JsdMMBj2XULuxusbTOAdFsDXxiaWiceVEjcoaaG5cCViSx9bs6vdhHoNbcOkX0tABaeYkFIXwXWCigTPjHI7iPeDP6O7S0SQlKxrADmH7oZGVoryZpsAHT7F67Di/XhHcCI2d/47C/3AfiHXm3ifhXAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 08-08-25 15:12:45, Uladzislau Rezki wrote:
> On Thu, Aug 07, 2025 at 01:58:20PM +0200, Michal Hocko wrote:
> > On Thu 07-08-25 09:58:10, Uladzislau Rezki wrote:
> > > The memory allocator already avoids reclaim when PF_MEMALLOC is set.
> > > Clear __GFP_DIRECT_RECLAIM explicitly to suppress might_alloc() warnings
> > > to make more correct behavior.
> > 
> > Rather than chaning the gfp mask would it make more sense to update
> > might_alloc instead?
> > 
> Hm.. I was thinking about it but decided to drop the __GFP_DIRECT_RECLAIM
> instead just to guarantee a no-reclaim behaviour, as it is written now to
> the flag.
> 
> >From the other hand after this patch we would have some unneeded/dead
> checks(if i do not missing anything). For example:
> 
> [1]
>     WARN_ON_ONCE(!can_direct_reclaim);
>     /*
>      * PF_MEMALLOC request from this context is rather bizarre
>      * because we cannot reclaim anything and only can loop waiting
>      * for somebody to do a work for us.
>      */
>     WARN_ON_ONCE(current->flags & PF_MEMALLOC);
> [2]
>     /* no reclaim without waiting on it */
>     if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
>         return false;
> 
>     /* this guy won't enter reclaim */
>     if (current->flags & PF_MEMALLOC)
>         return false;
> 
> [3]
>     /* Caller is not willing to reclaim, we can't balance anything */
>     if (!can_direct_reclaim)
>         goto nopage;
> 
>     /* Avoid recursion of direct reclaim */
>     if (current->flags & PF_MEMALLOC)
>         goto nopage;
> etc.
> 
> But, yes, might_alloc() can be modified also.

I do not have a _strong_ preference but my slight preference would be to
deal with this in might_alloc. Not sure what other think.

-- 
Michal Hocko
SUSE Labs

