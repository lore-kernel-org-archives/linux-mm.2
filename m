Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEEFCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0D96B0005; Fri,  5 Jun 2026 05:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B216B0088; Fri,  5 Jun 2026 05:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202A66B008A; Fri,  5 Jun 2026 05:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA1A6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:51:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACD1C140A48
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:51:02 +0000 (UTC)
X-FDA: 84845390364.21.6EC842E
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCD84160007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Np/UNrwJ";
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780653060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
	b=5fp9KdGIj7U0qmQUokm6pwm8FYDkc6Z99s6poPrun/YgKwklLV84ft5R/oovkY1fbHwxVP
	g4VS7NvQxqIQB4MIJIQCuNxIXjEXyRY149kE4UfqheutzmrQ/4tHFqhrCLb57WLjaOdWbU
	mfPdw7RpURfXJ2QMWaRZ3bE51Rny9hU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780653060;
	b=iP7hGq8EyDUdinh+zsDI5MRZGTM9khZalIi60GC1I+W2/8RVcR/KIhaNf5n5PPNh/leItz
	cUsfOyjkH9qMX4UTy1aXEqDx4fNAgj0htjSPCVq1y5Zi+C19a0Emrlr/FDB3rTJOV9ufT8
	t6diEzcWmwXEaiuToQ7zC6nnmHzd6lQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Np/UNrwJ";
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so1802123e87.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 02:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780653059; x=1781257859; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=Np/UNrwJ1i1mPt9ZO0Gyi9Zj7I09yW1Tc9XABRMNL54oAIseXvGFKCsbdPuWC8TibC
         k7QShYlFwgc6uA/d1jAZ4aUUq8LExE2RGVe8sq6bb46gAaaDGvBSFf0WdrgbfrB+oFro
         ULq9VNtAhaUR84mYEJ6Vl8DQQGbFq/RuQPAyiYS5PsHV04Z6e00PwxPsMZMamKC1Rkfy
         Ibb/2XZzmjxFbItAowCavIStLYq9a3Hbpw0cG2e/r6qamBT0Os247+LwkebRYLdWq3I7
         pahgPCTCF0Bky+2iwnldoi43SI7PwUhbhPDOBOd5vn3EADYulUkr4ou93g9GL+aEScym
         g0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780653059; x=1781257859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=qWH+WUqa7saKW7fZkCzcuUm7zbIlUXJ5g4ugaySoW6jtEXM8BE1SPnzNHsOQIL8nYM
         w/01OXYMXNJk/ZT0UDGVn9GH1GMwHuozS9GyM1FF5ZzbcWeQREKjAWQjzhVpnOliQCD4
         n79a1K0H5dfOCxQOZuOmCb1crfRnISWFFmBLOrLPjVaSr2zBpN1chkQPPK/rd3L6zcz0
         s9NJGVzcCMU9rCZ34rwWJxq1LI/mHat6K6XNpmDkytMlTJQhn2Ms+UESjChHtiC+5ZzR
         ebMAQ4BnsQaM4A7FsrJup0ufijbsMIvOTqKXvvefK7KV1qnxrtDabD9qXuKfNQY+33ZN
         pOwA==
X-Forwarded-Encrypted: i=1; AFNElJ/F3xS3tMjAT6LRRv/ap4FX8ECzAg667JDPwnZthUTMrWMYeNt1R8i3+YatzvFsWwBKJgj2dImNhQ==@kvack.org
X-Gm-Message-State: AOJu0YzrJaZ3nx59agc1mBQt2jViEz1SnuQHj/mM4+1v/nH+h/bIjWJB
	nkA4nm0pnR9sDTdt2FOY4IAHvKk6kKn3aLv+2xka66y19NFnjlPJ8rNo
X-Gm-Gg: Acq92OHX0n5JiwQjOrv1pya2Bq+3tLVO3ZoXswWd8o8E0jkxWIcpEFra/yisvWWTaFt
	4uxt3kWhsgTjX51HS1brcVtqyI6V8E448D79yY0U+2StZOmBWQhI5CmsFZMupiSCpxg3cH1POpu
	ayVkrR/gyTWPCjgJc0Q/Gbi2IZlX/GfV9OOMZ26Xz1KzcuxWzkeLO0Zd60PBsojB5scyHL9qS7s
	mV989XKFIahPIxzTomSUU+MgsxGbjLGjd2FsboJeI1UAtf4J+0AKGyWTTbadqeUUeIpE5enqReb
	kFIK0HSzIlB39CX6yfC11GcElsW60tq8+Ipddm0OQ0U7BUkn2DavnFNUvlBuSMmZXezLee/J/aD
	pP6r92HbVcmI7cCrtTscj01ZBjE+wABTXGvIq9NoKykxYfdu2u8HLipLvEt7eVPIRjV8OtPVwvN
	zp9d+MRntwyKS2vSZtOfc=
X-Received: by 2002:ac2:4e0e:0:b0:5a8:6cbc:60f3 with SMTP id 2adb3069b0e04-5aa87c03398mr899588e87.34.1780653058812;
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b97a71fsm1761298e87.46.2026.06.05.02.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 5 Jun 2026 11:50:56 +0200
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Mike Rapoport <rppt@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiKcAIbzz3z9vN9a@pc636>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
 <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
 <20260605093332.7b067876@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605093332.7b067876@pumpkin>
X-Rspamd-Queue-Id: BCD84160007
X-Rspam-User: 
X-Stat-Signature: 3eiwipsey3n1o7syww844tacouw57j4x
X-Rspamd-Server: rspam08
X-HE-Tag: 1780653060-545046
X-HE-Meta: U2FsdGVkX18ydjH/RESLMXHMbDOI3yUrX+NG/+HpPKtbyWNsDhvenpion1JWrk6d3jmj1M/Pxk7y9tgeq/IINi/im9YeqMlY0EuEWko5zS5ytLCSTMsj8NqNb2GVahlbU0Vlu4TG9WC3tSyaMSXxV3F+PA/x9u0LxCl0cc+5FDoLKx7QP0MtApCiOXGyHJCj0MAwo15SkQ+CV9UFpHVG0aCpm67nUDZRHoBkKwmnC3CTpIZ5iA7I3fEae/OJKKIGqKY8Z2xIYhm3qz4WXO3FuwXyO3ozemm7Bvbr0a4/ti0WavvwPpwbxBYMb8+o/cdt3vWFLwVafFulVVX60vozLV5dFmJszoaYrYio7WVzux1yvaighageiYEqXNYJd0RWC4XdW44rWsM1XRZgfIlc747qfWL69UzStHksd2JWsnHa07X2zRRAbMJwt4fK78/B3a8uPGlXbQ1fLOmP0WjZMcyXuAu5XHb2BKrvA/Vv4SzRDLSqjj9jZy5SOpyTYi+uUP7yxqL0xF6ZqmencbOeR/ZEwGq6071bwCK5z95t9jyRGYtj/cG/7umSN1MBkymyUD+no1hsmLFggRPsxap14RUZV9x3lDiXMlYKjxj68Slw6Lll5hyO5SDBBLMcAfUPvZMsvPIChtA1CM2DZHoNH4Lr+aaKjLjvjP+E9SSWe78R8feyI5ws91YBkIcmEI+qtiQ0xdx2bDyqmxfZ6qGuXk63567AR/+hmfwCRyemMyY+nq0NjIn54bCavXwEabmRtrPD98P9w/ytTZMRiINkANJEFaNsMOsyl4yoqq0Hkzuu+XV+evar2TGTLvbtKncOfXcN4PrxrQbDljXB14PSmheoziiZ/G6kKvOdK0/cooxKx5uuwpO4XmC+AF8K8eos12BlEfZBEX7pZk9mcIqucZrJlkciVIgLs9gUb9YxYmQS6z45BTHQiWarJQSWm1oQ5MrSobS0URb48CMqWOz
 6irJsSxv
 XChGtZ0PMFtYGknQluthPO7p+BZwihkCgckqB4C/1LUBalY8kGIEO2FlYa4F6NxGLQgVOyvXgsZtJudIojrk3U01gkV+zgOOsfwD0sO6GFyYnReTdGJNvtuIByALMnxh/cHf72LloUx0niUH41lnT0fdpf6+A45EqNBd7NFh/PZZZ3EcWOPV/sBQqi0wlWLB8nUVLHOEtvGGCM9FL96YXbEVVBY9Au6x806Vco79w914ZgXyiGyUqV26bayuSxxmJDGsYoIbYUqObLNXA6P/DldyT6YkHAjNcI6TCswBXzruG/4zMx0t2m1iL7GgO3xAkgx36zcNtkf7Tsm5TdOL9q3VMEDTeThUSD7uAJr9jBn2wnycERgQ2/4h2U0QP61S6ngxyObYISpqI2kaXBTT1jwZC6S6M5YfrNeUUu/WVEJYMyk2GJz7jtZiEQ+zv9OlcPHLoRCwlQJ41dxtIpiaggqvFgEsqVLVHf32WqbkcMAfNgjmuaxg4xqejqFxAQ0YIS/G3XImaIT73mb8quD4bZVFzdYRkduwZuiwcf9r22+SIXdmwdJNxlnQrVKTWrtgKcZuldVKx9BxtosnUaZibPBLaJHak4h1ca96R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 09:33:32AM +0100, David Laight wrote:
> On Thu, 4 Jun 2026 10:05:52 -0400
> "Theodore Tso" <tytso@mit.edu> wrote:
> 
> ...
> > I suppose we could do it with kmalloc() with some flags which to
> > prevent forced reclaim / compaction, and if that fails, then fall back
> > to vmalloc().  Is there a better way?
> 
> There is already kvalloc().
> I'm not sure how hard that tries to get kmalloc() to succeed.
> 
I assume you mean kvmalloc()? kvalloc() is something unknown to me.

--
Uladzislau Rezki

