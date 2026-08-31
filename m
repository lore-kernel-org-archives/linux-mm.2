Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA9EC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 18:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D2C6B0088; Mon, 31 Aug 2026 14:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDF46B008A; Mon, 31 Aug 2026 14:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7A76B008C; Mon, 31 Aug 2026 14:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B28E6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:55:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABCC416021C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:55:29 +0000 (UTC)
X-FDA: 85162467978.17.3B001C0
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id E20B120002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:55:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H1I29dlb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of pedrodemargomes@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788202527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhaWswkQxW+7On/cBV4TuoPoc9NhNmh0fp369raKMHM=;
	b=zhej5K8YyKW12KGTdcYjzn0a9hwThwSsf5qo3VbQDUsSy9KfO4Ip8BqU7/CwMPmi4w5RVK
	ANcboIm52XMcHjOZnVqIv/7irjJ5gjSNwbo6MbEf3rebyig/eVY19xOcjhRcRo9he1KHk3
	el8d8aESVOKJfANqSb79Kv9q4TM4Puk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H1I29dlb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of pedrodemargomes@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788202527;
	b=EelTFEHNk0Sta1X/dSDU7w4745u8jeXNT4i+6HurDDiJtwz2NxyF6LN9eJIJv8jSpZsoNV
	OOE4zxu/mx2uqoOAFkHHzZ+Z+5LtQ42TyDknniWqlqv5+w4A9fQ/80wWcZ8aoytM31MBRk
	Ynf7uqCVFHXd64BCIyDQFB4OBXdTQmA=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66e63c2c9e1so304473d50.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788202527; x=1788807327; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RhaWswkQxW+7On/cBV4TuoPoc9NhNmh0fp369raKMHM=;
        b=H1I29dlbr4LNz18lxZI6tIbpQ6IH7EkRPEawwz+TOCLzfPfnhsWVJ5CcggxXI9eyon
         gTl3iu0KJDdlymM+ZDPoCKppewMQWsQe6lZie+PVhz4PyRBRle2hGTPWEzZV/o/Pcli9
         J0R3YqzHwyaUpX6IqOnCJsCwi69Ghxxf5U8NvPsG//cnC7N8OcZr5NhF9sgf3tiYtiIH
         zRIsMX8N/vPiPuIiVtoQ706CKbIZCRKilZ9PlfxvpLL5CfSOlObi7LfOXw1RVVWj83jk
         ZKaFaauhulL16w3wr8LnAT2y4pHpevn11x7kEl+10LNtOhHMMtWVzJ/oNW5sOPwLo8MC
         HL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788202527; x=1788807327;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RhaWswkQxW+7On/cBV4TuoPoc9NhNmh0fp369raKMHM=;
        b=Lr3aJ6CyZzFFAxHFv8+yOegqguD60tU8lbbDjaXu8QnliHnbw5TMj70Kdu2NSUQRUl
         xVTpUOMmiZ/eH77yCTyUgTAl/ydNS5GeqSshiaeKD3u8EHy5YejLGQp41K7g+ks9V3kS
         l3OkeX4gQkslHliBZhjvFEG1mnWXclDhjnzPas31WXP6YIj1EI1W1yFJTWYcxbQG4otY
         2zKiE76ssF9YteebgYg82ZU6XyRsgBHDXMDIDrzk7QlIuRjSEK9IAF1Q9g4bWgHEbZ5U
         hVEo9wXnjddjyKxIlckIUTbDImJhExXdKj7NBZYlWAxP+x0GtlbGFRwYGiYjOnt245Bb
         ChlQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZUZJFQANZkbAIcC6KzkjKrIM53/GsMt0mNr+VUdTN/0IE6xA9Fu60ZSRm4gyIggm+V2spiVqrOw==@kvack.org
X-Gm-Message-State: AFuF++mMwZYCH0onGNKcoSkHCaitbp8f43uVnXjP1+bpRyyU7jx7OhWm
	9TR5tnIhaxCw5229CKJXTRzOXOpQWGcsi2DNw8zIZhyVgpkc6RQfoi3c
X-Gm-Gg: AYBFou2nfgm4PldKd5Dr9ADy8H+9XEX5VCgowU47mem9VKA/7gKQyuwnOe2acmWxsEY
	vkp+A92l6b/M6JT2sigSE+axOOjJ0xBfZ1VctnS2AsipYm7jXW+TCsSXzUylACFMtMXARIno8lO
	N+VW4pxmtVu6iWPfHXeuIGtuPYWYp6FzpiL9Bm2SGqyySmBkvrMBMJxpb9Vi79yfj8cvOlAr3vB
	0IEY/PlbXzUjjAoel98nCUQE4SClI3MMqpdmYo+Xk+iiz/4ASwr5vwOouqUu6fJJmGhBCCwA1B6
	BgFO3Y6SAuaM/auq2xw3EE4EzXKqdfKq2jRax4w/BNWrlT85zRdPuN8EH3Y2IirFgURQDlSIj/X
	0dG/00GQUguMEvlyHUmuOTPYkMwZwukwy5pBCBHC1zxQ+uxdJF+WMUf1Y5jiMPJT/+iDb4tn85s
	Thtqqvc+Dl04/BXkqaQNV6dv24ekIoQdwDvTpsXPVWV2OyzTB7vCuMsHXnHGNZvXYA/xaIVw/aH
	tBP/vEiEIR11U3F1DtzSdCq
X-Received: by 2002:a53:e904:0:b0:66f:8a2b:b693 with SMTP id 956f58d0204a3-66f8a509c19mr89306d50.17.1788202526777;
        Mon, 31 Aug 2026 11:55:26 -0700 (PDT)
Received: from fedora ([2804:30c:1f03:a800:30b7:8d7b:fa5e:4825])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66e4ed2986csm6636227d50.18.2026.08.31.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 11:55:26 -0700 (PDT)
Date: Mon, 31 Aug 2026 15:53:34 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
Message-ID: <apXHC7uYXE99ZgPp@fedora>
References: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
 <20260827121151.7837-1-lance.yang@linux.dev>
 <apBB01VBbmV28gWP@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apBB01VBbmV28gWP@thinkstation>
X-Stat-Signature: iwf91qw7eeyb3zurjb6xbu31styidpor
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E20B120002
X-Rspam-User: 
X-HE-Tag: 1788202527-34517
X-HE-Meta: U2FsdGVkX1+KqA/5TLqMtTnPtEa4DBwa+mxv9T4uaYVlGZgJZAh9sSFpNbBvbY3W/gCNcX7mAYNorwCAMTUvrQJkurWB66bdwh+5lElMXtX5o55ufeWdVsKD1WgYILQd3y4BJ+uZXxcncPBe9dYe5cWxWY9iPs18S7FBPKDs6EsdxXd5oRTILbvxH9VnS0zeYQscIKEi1eW6AHOZLSQiLb5HvO2GBNcYQjxDu6cx+aT/zUoiF3TttRkFy0gVlYX9Afs3IApjR7ogDNFxeShrKlER99nUi+J8FFe4UGNub2E/eTv0RHShnV1j8qNLS1+vMGNLtp3strTu7lr/zXFUSqiZjVifWvOOYk4qRZhIQGcyDG5nD/IJZ7tZBL/f5by3/OBDceEZh+Mve+bsU+3K8sfaRCjSNBlhGa4qLSbGuvnUzhZBTdzjYkY8U129sqgrbygoW54zEqBS+51C9XCWA93Cd8YqgTW0WSU+TcnUjREkPa9M9tNSnJBxc32nOQwBflelxmtH8RLRDgLMAQCXChUtD9Xtfs6aP6BGf/RIEbM/7WYrNSlfvVcAGwOop5aEkvhDg20pZwyVrt4znzLmk+28ppanRyV9/vv2jy8fSX3m+7BHDjCYrvazMvlvhHVxmtBBxRGXfq9A6yfnaIHQAk7297ovghprgM3+OnagN3UQEx5b59K/QtmNcamYpFxnpcvS6noDlDi8YAqghz0F4CoakcfMj7FKSdyHyNeK4AOc9ue4RIUozLOJjj8g44iUz+XJ+LR3uT8UHNNBlctpFD8OpHz1Aaat5MQj4VKSzJtDb7EV4tFxzKTCylkNSpWdHR4jAjgdawC22PxHMqO94Dn5lvX9LH3S2CV0g1V4mEYOmytlkySZJM/psbjtiy+tez1IUN/fzwu2HUcbJr52PcPwObaLDNr+CP+nWPInDrJcggmYa8l+6a1tGrgsV4ZtEaa4gKkTpNuk9KV9juF
 jwllDd/A
 b0+nOILEIrTFY4WMkCBWszuBo+zcukaHHX9g2ot9w9hUN4Q7WR0E94oNtbNhdY2hIsJs/+ulcxBQPDLUAQPivrVT5rHecV1RjQyDiawgyNVvLalSjop1wh7LHojJ9bJ4N+LsyTHxLth1zD8hYYs4MojvleTDkfKRFuvRSjCa1O8ERf9wqqmmimCCAgmVIAIpuCDOxmarLQVhYGeKH0uIKjsTg+0na6kApjsXD8GDJHZgSCKDKSCPJUBfzL62oSSnC1+UuN9xGFhxlrwLKgjR2u5qs8VPahaH+4hjf/bC7dXpQjtFvBLcU8BMm6b1Y0sZel9l8c6k35MFWKo6RbWQWV8ZZKpaeQZVAOIdD+MEjgkdq1lsH7uAAtd6Q5mcDa4znGhQHWEF4OKJl1PgoifsyNnTWVFoQvsAi3uQGdGB4ZBpAFpR7mt1/EJ/HY/q2cl7EJgerpzoSMSXj4AH+CCOP3yXV2m/YhoKEGoYM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 03:07:10PM +0100, Kiryl Shutsemau wrote:
> On Thu, Aug 27, 2026 at 08:11:51PM +0800, Lance Yang wrote:
> > For the candidate above, the loop only reads its PTEs and returns
> > SCAN_SUCCEED. Pedro's bitmap lets mthp_collapse() determine that upfront
> > and skip the walk.
> > 
> > Emm ... as I asked before[1], any numbers showing how much the extra scan
> > costs?
> 
> With the win being only some scan cost, I don't think it is going to be
> measurable.
> 
> It can open a path to future work. For example, we could find fully
> populated mTHP windows in a PMD that is not eligible for collapse
> because unmapped > max_ptes_swap. Right now we just give up on the whole
> PMD in such cases.
> 
> But there are more wins to gain there. Just saying :P

Hi Kiryl,

I devised a patch based on your proposed future work idea. If you think it
makes sense, I can send it to the mailing list with a Suggested-by: tag.

Thanks!


