Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E60C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6422B6B008C; Fri, 25 Sep 2026 08:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFBB6B0098; Fri, 25 Sep 2026 08:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493926B0099; Fri, 25 Sep 2026 08:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 250496B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:16:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B681612025A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:16:09 +0000 (UTC)
X-FDA: 85252181658.21.B191813
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB8221C000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:16:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u oO3HbD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=vrZrJRN2;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790338567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE3icSsbiy3N2VWp/dD2+RAYCNaC0ptEBgoeCj63aE4=;
	b=O26cJ7NqTLWyXVO/p+/Za6+IELpmMb0x/sivz7oArmF/96snjY/Fmy6544LN4NYrX7bkxl
	B6SYI3sxI4/CJqncG8+wRE3KWM4vvXS/y/uny+PxFErENvL8/L5D4zrpkvyUBYjDjgcv3N
	zuitmwoyg5xmBKBQB00GM1XKeG3shmc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u oO3HbD";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=vrZrJRN2;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790338567;
	b=u4CpElf7oGU0PhLClIfKwawqJkWL1xsQFHTKRW2eDpG6PQovQCCNyB+A0m/4EMO4jTH0J1
	T974lSBkboAP/9f9OamVzusl8qZ/Oqs3gEmF1s4iOmWr3kt7MGj+eBFU599DvYGiN2Tm7c
	eP+3JsuLPS3vo5TA1e2JOO0we/nfGnE=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 29B4613802E1;
	Fri, 25 Sep 2026 08:16:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 25 Sep 2026 08:16:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790338567; x=
	1790345767; bh=cE3icSsbiy3N2VWp/dD2+RAYCNaC0ptEBgoeCj63aE4=; b=u
	oO3HbDTMvzSjBTfu0vSMSG20/4+P5SSljPih4fqAZsAljFGM34GuB4SBbFFwihyG
	Kz6JcG4gscMpEH7HR01MlL/o39RIh0+YNKLEsryrnD0OUj1gDO+Vvnfw0th1xxyN
	yfSPryyTgGbgcNwGCSKbez23H2yTdrktqW+J0RMFeRp/8WqTm30VID7ig6fDBs54
	rjIcZz++OBOjMFrXM0H7UDmbb+l3i4o4O2DaC7wTSPznoYQhcWFQoEcTBAa7ucWQ
	6rpqSk7liI9idy1tdm5mrqyqoyW2/wDTGHLaW0S/Q9jshIWkJl2TnE4Qv/1Hkcz1
	0EaVMJpp9V+iI2SqfhotA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790338567; x=1790345767; bh=cE3icSsbiy3N2VWp/dD2+RAYCNaC0ptEBgo
	eCj63aE4=; b=vrZrJRN2Wza37yNqIZh/jrsa4Xss0/PtVSDbeUeb2+AHBtss59r
	EFdojLk4LX2pR5K5N++3nOgNqAtaam/MGzcV7AdLfeX99K85wHV9sJZUt0ieE3mD
	TIgsrFKCuFVUJdwhMRTUiBOvpHP2fZzEgK2bbBZk0Pm2IwblJrreyVQ1e9bxNnw8
	MCPYgJzf1u3jcRQgkR4eLBz3XmlwnBFAQxTa8YZ7b1U7Pcz8a3M5QhujOs/i1bnN
	Z2pSmtdE6sUE4OKJVsH02GHl+YQvxkrwi07jmq1JF8oZ2Kd9dkuyKG05QgkdB0IE
	fRkjefglPMJ6AlnQESc+hWRaBuwkgmq9u7Q==
X-ME-Sender: <xms:BWa2ah04dkfznp_Mq7xCQA3hPM0LBQkYHxSTc9dT-dUoIpbadIV8_g>
    <xme:BWa2akSeIGdRD3rsw-_7pH_JrJjdK7bmrGrSr3_HJ-kiEFwjMe9yRBjq4AQIryXD_
    J5S1IY-HR84nADiAL3Hfiq0vp3RVYrzPCfJUfq0vFQRlq2jKaTf4Sug>
X-ME-Received: <xmr:BWa2apDhlBpKd5zcw69FC3R7kCBeTMNfEYQdolcsOxR70kpSlsRobbSPmbQ>
X-ME-Proxy-Cause: dmFkZTGENxxHCReKKchFBlCElugDexOT2SgXO51eQoL8Y4w9wHokf88d5qHkoAqwAEu+Ot
    t8ZzOTusjDUfiQ+XBNOchMvs3uGoOJYgRjlqgKUgpZBHiH3/syYTBdlQ8hzyctN3cnU2UJ
    5ELqyyD9Bazuu+xouYVyTy1fQiQFz/TweN1yP1Um3LGC0ua+lgwj4Dm7eVdwK2Jkl8O7rG
    NeE5btIvzL8JvnSwUyIc7tfjEH4UrGOfmpKy6zXPskbKb8y3K5C3j/SmNetnp7hgfs1e8t
    PdMmja7l+vMQkOJTrG9t9chjSIpU8Fatiwnz3w4q9A6CwO6gV8heZoIPD89w5iVzmpDUOY
    U2PbF4jmsPgDkH9GuMhn2Ce4EX1sxAIA4Wr3JeNrHo/qeozOIxtJAddczxrNqAzZNfkspv
    DMECJC0UmMXECKTgkbjgv6OFrWcblgsY8GZPuQ/KrtedDHxS8Q+jcPS492Rq3jLxf00DEx
    E5tkqKl5Zo1JMjd2ubVYn02xSd9tJ4zWkWhbpsKelBY+mf9I8rpg79ImCwsmZHgS481t8V
    cZ/vaIwHPFeJWAf0ErmdbzA5oqMVAbpAAQK8jZIAx0T+tMb7iElss5Wgql+CKTNLocbssV
    UBni1q1v3Cyf5a5Bl6uNxJpPlhZt2OYxbdu2mB9dHD//Fd0d5L86rrN85Pbw
X-ME-Proxy: <xmx:BWa2aqbMVtNdazsZVAdc7l9AF9JU13nCkocZYo3cy-7iGpMsZVMAGA>
    <xmx:BWa2albmTXZci_o5UCBPCzfeQbMVzo-kHEvnwfE7tOsxINkF3hytbg>
    <xmx:BWa2alksIXkc_S7oJ8igte7bYRfEV8OZ8bcnOiJLk9Nh9YXGj0Q3EA>
    <xmx:BWa2asMK8Q0ZFBb_3D9Jex7VKsytddm2qL4pfpZSpAThKrr7JgWJtw>
    <xmx:B2a2avM2mJ1hTwMIjaHr-UUE6gbLHPEEUj_T5resSS19Y-QT0BSLzkhb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 08:16:04 -0400 (EDT)
Date: Fri, 25 Sep 2026 13:16:03 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	david@kernel.org, kasong@tencent.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, 
	qi.zheng@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com, hannes@cmpxchg.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: remove the unused zone->unaccepted_cleanup
Message-ID: <arZlCx9oAWXr71Y3@thinkstation>
References: <20260924191103.3475117-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924191103.3475117-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: BB8221C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pqi7hcrys4ojbr34sakdjntnhzi7ikpo
X-HE-Tag: 1790338567-686501
X-HE-Meta: U2FsdGVkX1+U4ynslFv9knH7n6wSHze7vKAONTCknN9RcTBzxhqYMHHNZoAX6s9d6/qewWdFqtG59jXQIip/urki0/f5vQcbm644TLaKhm6S9ONu6D2fo+MloI9pQCyu8Yj1c5VNUW6pzx/TtOojXBHFn1rJQM0+6BjQjLA8WoOLZrMz44JDLuY7yDwTcIZeeQCwA+CLjVDKTfJmvopth4OOyC+4eX5TrX8E23LWhjtZtqns5pAFAKdy3/0mzo+ePTxwev8rDTK4lBXUneC72qnnvO75qEpnICTwSojS2Az2RVcFc0q8Alwi3vAw+BWUMzXEvTeNBlLZi2Yt/iOQHhODVtLGRzF3MIcqkxBKlXLOaflgS0E9x/bjOiaGymSC0hPng/XeXhU5qbbFuxmg1F6Zixys17P7zOUeQ3GwAFdsx8Xfk43q0HBkLvF6h119CBW+1AoVdm1MW8Aq21SiaHfmAKIvS8lXk/5l3tTEJ+BZ7vUtDdBJm5B519MWBPXfORQgoNGdL8NJdbTQH9b5oHujJp7BCO00DGb4fMhMjuAdfRDud216mc6gs9ThkQMhL35tRwQ/bSiwqDcvrFoTumwzoM14khVG13Y/4R+bWGYiqObFaV/Oh2dzdyOecyO/3I4lVxwdmHI2sbm/xKI20glEc+uMI/ii44Bb5jhmeATLHVXUX4D74bGQxtiHQpj4vzxjN9TpYoAn5O6C35Z1Ixigy00AiOS15Nd62famX/MxShZRskPtbGB1KvsOzFfmUsEHY1m+vs3FkXva/hidlXGOe/iPj9xvu0cLD66A4EfzpC5Q/bV1NbfbA64apaCrIaqJzgI2QVnSoIjdLak1Tjrwst6BQeYbnSrnkOFdAgpqzgYo9DqpEpzjTnnSBFl2S3AjvJRJdzan9XatVIukG3MMj46zZJIYSPDMZGVuk9O3GNmsnVruzgThbM61nIOnN2Rn1Zrd5s3iFGN6KV5
 sTj0WrPd
 Fi0CpilHYdBfPS9gIlgbmD4/xYULygHz3AtOFFkmULcjnuUTMOkb0pK5g0cxb592AoHxNgbf9S3wF5DLCmhEbkR30sX7sPbAk8SjtoF5N6dlcGh3BUwbwdtju+ekHgImN1nppR233Jq8kP+3dSAr15OEorz9Nq6oP0xDR07AOL5L92qWF/jE2UiXeBXSS/7aQE6WVAi7CWan5JNYYAnXcFo+7KawlRccG0HUgQa+KDPK4WfGegXIdDZuzy2OU+h38z8WdhyPEOH1SPQ3SpxlnyGyGKuqPHnjjv/HXeWYpgDv2tQUUxJ4serYhy79oKBm5K1NN4o3hO7VRjN2hqIB0yGBbDFsrJkTc0+gBg7fW1srfmAEV3mMuzXLWX8kKL0dzgY/fy8ZdiR5VP13H4wYmEVXvQINEIL/ijfxvC5wwpUosDfJBvlbzp94iB7zH2/qbdWf0fclwtPfbzaS6NgmyzgQ76gEupAI98zcOE98S4ayLI8cOdJN8NqJLu3Oj9BW+ntODhYzD4igh1Ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:11:03PM -0700, Usama Arif wrote:
> Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
> memory handling") removed the zones_with_unaccepted_pages static key and
> the work that decremented it, but left the work_struct behind in struct
> zone. Nothing uses it anymore, so let's remove it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

You missed me on the CC list :(

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

