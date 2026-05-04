Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C43FF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163F96B0005; Mon,  4 May 2026 08:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114C76B0092; Mon,  4 May 2026 08:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002E46B0093; Mon,  4 May 2026 08:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DED3C6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:36:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A8DA896DB
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:36:50 +0000 (UTC)
X-FDA: 84729686580.10.743A6C7
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6B6C1A000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:36:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XNvQXe27;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777898208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ObbHgO79iWTpdeb3bVEymQ0c73qV4KX+gaPzQKE724=;
	b=uJaTF96oC5bj5+OccmEssfUnY+hgn+z+HXpqW8DFfRJXmsMvndJ8Oa8DPICCb5TQghnx06
	cabdcsedq5gQEp97Z0MVZKq5EXRUw4i4yXfGIGGg/WYhPDRKN+5duM/IJKfYFMd080mkI3
	bllQ8b4mqwaYI7GZ1RIwMV+Ioih5l4Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XNvQXe27;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777898208; a=rsa-sha256;
	cv=none;
	b=gC71qoqF2Sv8Q+9ZLRx124MrC/KpIGjXPA9ydEJYgm3M45muJzG0YQnalP1CuCsFTTBANH
	BeS8+PvvgN2zFsRjgYKHYQiAar8nzadod+tGabP0g+bIS6p/ZikioVoirSFB59zzyhtQ3l
	SDYbAE1QIYmsdUjgiT+RorOfvXH1rNo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso42741405e9.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 05:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777898207; x=1778503007; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ObbHgO79iWTpdeb3bVEymQ0c73qV4KX+gaPzQKE724=;
        b=XNvQXe27QTheJ/BndHwE/EszlZXU+oGfjwzUW///tP+8mNXc+d7Fv/QpooWMpi24Nb
         Zu5DbuARm7az42NazEyewG/uHBjnJN6JpFZQxtY5nvoymKOQSwCuNPWKMmIPYhmKYcO1
         kHJoYbHsFT/B09UmhjgDzucduQ++LVH5+sfdXpnTG55Q51RncAN8LIzAICXfviiVd5nN
         5vyZ1lqXedsRHfUkDUWHxf4rAw3Jm+3ukU9Fsa0xYieAVR0rdJE4t5WKJDrQWtAuf+J5
         b9ai4HP2LJuqEd12R8J50nXb+RBBtPbwTxYurp6A59srpWH2Pc4XEodZEtwqHYXfbz+Q
         +sQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777898207; x=1778503007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6ObbHgO79iWTpdeb3bVEymQ0c73qV4KX+gaPzQKE724=;
        b=o6bIkCQpQfmFX2e7782JfX0sF65Yusw/mtYBHC6IpIaqC+7jBfJJOAnsMN/Q642dPO
         Cf+pIzWiB35m02qBTp/mKUg32BMq9bdgpWpbMOL8Auy3kj0rlfh3kMt3resu1d+06cfY
         TLfyhx5cE3C/5JnIM7WixgAlmab+LlZGp/h1eQ50HhHH6fssOxAOWIeopXzNFnC3vTTv
         vxWPpDcoJxVC6PUj79Q5u/1BKEJAKg6M0nodBj87PHO4Mi1/LZXu+bDSOMdySpA+/TCA
         YR3sSzi668yK6P8LDE8w/kJYYvPaxdHUjLCZ9T42gaZv6QQbDL7Wp7dV3n/w4sJPH46q
         03jA==
X-Forwarded-Encrypted: i=1; AFNElJ+ePX6CfPSAzyYNAxfa9yc6x7W+gLpjtWcJgoYElBf2ZdOx6+dha5vTI0Wvmcvrp4aVX9WuiXPlxQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7oaFJ9plYmj+Jza2hMtA1yyn50Sf6o6aUllZw1NrG2ZRTCyJ/
	2axWSr3ASrWm1Emm4/WZca7KLio3Em5liq8rYILasbsHhLOUpvd6eKYe
X-Gm-Gg: AeBDieuOkGWZTDzRSUB6XactZXkj/tD+fb+4g93/C0cHqtSAIonWyYst0k2sJswwepp
	UVM/u5xgWusho/VQHJMbwDbVdDZpJvUhgenqlzRhZ4UPc5ySOVPGzumwVerOEZeoA94korzKur9
	RUwMiI844dI8PU55QpkpN4FgS++vIU8npNL77Aug8387wov3vzTDGNYRvmYd8Z6gOaDMSNpCyOW
	PZA5l4P2lvZaXmTRYrwc1ut51kbaMxW7EePyfTp8Flnsym9/iFjVqKggt9OGuuj1nCsNbJhSy9b
	fwWybVLoHYVyDab4/fdBXpJdvecBf9HxeJ0b6c30aQdBJCNMmTWVFfr923EqIiZT+5rbaTghZvl
	gJvforFBSsI/VKHChoOBTQNj4G4FISu7vK181JKFOhy5dyoSoAGtheNVa78jHz9ZTaEcaGZ00ak
	NZkL9rpsEwIpNPrcobTNphi9tp9WQkccLyfVBNou7eJ2E4X2uv3u6zmQDUs0ujh1yb89jkTIhif
	Hs=
X-Received: by 2002:a05:600c:821b:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-48a9852f4demr153842675e9.5.1777898206658;
        Mon, 04 May 2026 05:36:46 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a822bf3ffsm352036125e9.7.2026.05.04.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:36:46 -0700 (PDT)
Date: Mon, 4 May 2026 13:36:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann
 Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mseal: use min/max in mseal_apply
Message-ID: <20260504133645.517d7a0b@pumpkin>
In-Reply-To: <afe2k3jhDIXchVeE@pedro-suse>
References: <20260503115915.18680-3-thorsten.blum@linux.dev>
	<afe2k3jhDIXchVeE@pedro-suse>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A6B6C1A000D
X-Rspamd-Server: rspam06
X-Stat-Signature: ru367s4x479cu3pnt7e3neyb4hdtkm98
X-HE-Tag: 1777898208-483910
X-HE-Meta: U2FsdGVkX1/6ZeYOEHBaRP+8AGl+5EM1eayEYgXgzFuKTnR2UJ3LKLyYN8WTOFGt9pnuR1LFscwZ8wgo2w8HixhjdDfBhuEj0PwNeX8oEVC+XP4KzaEPvAZbivpHmhBvCyXwYhujhkkdkIcSBW1yr+ZkHiXAbJ6VS3W8mnK45YrdOhPZmwb4+PPKxobSCcMaNJsqYaqiidp3T1J8ChcXX1mN7aCe5rd0Syzc62+8AMMZHPnM0pldw/6gpBLGlKcYrcYQqY3Feg2R5wV1ymfkhtPLqVycnkiMbpHX/jO17n5gIU6X003ii7EZImOPWvQys4zdsVFaeZc+M7IRwZjmoHq7kfFaLKqfYXaaWvrgXK8fLzmWqy7DcTAxWFTJG9ou2gL+ISrZOxzoGLXzgArvHa42TPB+HJfE8bfh9LVpFDMKbREIlOHwOrwxn002jIl64YolQBwNSXLTA0Sc3bBxEUkWtj8hhuzYWvu79l56txKgdsxmVh1m2Y4W1wXvgjYk8d6rdwuVywW8VhVgv76dFtTrqeKSh3JRommd8zuEmoMa2ZRP/WTnoqoDzk0/9lSe2HmVjhJ+wRRwmKESLf55AXS1axo8VyK/GIXx557sqp9FiRYHzlxIiFuyegLvIWpbE8Z88edkZERlzxmR/cEzWJxjx+7dUIlaNAU3F/f54C6VcxrF22m+a0gbqgfPfu2d93icQ3zSWO6MYH+Og1mr8EZhIyiyrVv6Ban+tosrb5a60MT/xAu/U2OFNIKJhYaTFAV5MuXX6wrt8YpsqeylNu/8701hX4PU6F9lYqJ1qmZ1ZWj6BteG5jIZIt5hUg/Kj3Nb5Pe0l1aOp8R8tRdfIkMOFm2ikl7Kxa1/q7qVr3UnzXLK45L/HMvsn/Dvtj6Ob/as3sbpM2NLdJWZ7YJ5tQcw+RO4T5nzMby2BuPvbay+iEEP5xDjSZq955yjmiq+6j43Gc7RwNyju8RIOEc
 4xf8+MdD
 IOEcegLtd1VbuqwqwPSSw/+ZA0VzOrpPhEjzn3hIa0XdTA+OqEYnUyHgTGb/xPqE0OIxFunzjJuKwCJKxlIH/jqQxeDYAdr+lezDLOeOjmZWgJRpX4c1yJMeAiDjK6VePJFbKyRTd6ju02nsjliSvWl5Vryll8evh0RNaK+D7+WzXb2lSukT6/A2negvOwEIaS818jWE8wqnFKF09nlepPv3lbL1rqkUjD1NQiMOdt5irROz/GUHxUTzvp1Fj0QiyyJ/rGIIIrEY5W1sVJpMJ7eHXs2TK/biYvj+aR454NZYoO8aFFwxJ8ZoZA7j7QIpc3EmZA66FwH7oPflO66pDt0TsO15lTYANiu5CaKTsDiLRk7Lp1UX7S9WAgMlDF5FwWss03Ag4LMCigIrVAYLB+PCnX1ZmCK14p4xE4bkerEiX6dnxRKmn9SeTc6ZlPR8aDAvSgqS/nOZPWYU3uBGlpyR0eXl4vdwjiS+x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 May 2026 21:58:57 +0100
Pedro Falcato <pfalcato@suse.de> wrote:

> On Sun, May 03, 2026 at 01:59:16PM +0200, Thorsten Blum wrote:
> > Use the type-checked min()/max() macros instead of MIN()/MAX(), which
> > are supposed to be used "for obvious constants only".  
> 
> Gotta love these macros... FYI this isn't the only wrong usage in the kernel.

I failed to persuade Linus to include a test for __builtin_constant_p((a)|(b)) :-)

-- David

> 
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>  
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 


