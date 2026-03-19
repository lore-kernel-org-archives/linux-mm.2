Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2226D1091916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 20:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D23A6B052F; Thu, 19 Mar 2026 16:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3832A6B0531; Thu, 19 Mar 2026 16:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299026B0533; Thu, 19 Mar 2026 16:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17BB36B052F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:12:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BD40140640
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:12:44 +0000 (UTC)
X-FDA: 84563910648.15.76D642C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CDBD140007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:12:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Po9XJlj9;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773951162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qy6Dw1aDPxXjtVG9+WkmxvXxxHouCCkBuOmK+4REYK4=;
	b=JykQkINdT5XqF5PQpGl9Mq2vu9oW8qIpVyifl/RafybBWofuxpoC7KXPzegdpjLwy6yYCh
	05Kh0lOgbH6o6Bx9ZAxgGJkwZjSaCTe+FH5OcDrEwWwPZmRrqTk+sA81cd/GiPhWNDErk6
	V9JDGEpiwPORXWyedV4Ko02Z6k3D0B0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Po9XJlj9;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773951162; a=rsa-sha256;
	cv=none;
	b=tya5m86ucYzKGQlt6iCJRKk7sB/plWmjuQfFC7iAdftTonvS4fKQyH46OhWabYJ4YvyXql
	SDm4/gRE+Adi9q/JLyqPFICnoBNXhOrFfjtQacUMnWkcTGNI0ZHOAngkprm+6c0o46wq5E
	jTehFCOXyYpPzYwMtvDCRKW4vH2KrQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6A660053;
	Thu, 19 Mar 2026 20:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F9C19424;
	Thu, 19 Mar 2026 20:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773951162;
	bh=RUNNQNOc9YnBPWpX2JqssxtPvNCwOlMdV1VPxAuBUTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Po9XJlj9kP/fGKJurAFjhBTmIYSFbwkerCr9J8SssGXIxLX+6yOcyqiLTkWFRXvne
	 vemaGMU4/41Jz+0rdM8kGaItZPLZv3MoaYXIcTGHHqmwrhl2yOsE5Q8e96aOcEcH5C
	 vMpmBPR/hxf8owgzbluLEp1YHlOwgWdCy1mvWzQxvtvNj5Kn1SGsPDQt1IRwC1GubX
	 sshATMUFFgJ0M728l5b677zuJ6vSgfCotOOjUyXKKr2ti1R12JSkWV6CxbHHlaCeZ+
	 X9q8FBcbk+mf/4qEYK0tj/T993Us51Po5SCK2ki6qBVR+2cjrOjvjUpckYUd3AC8xt
	 qIMG+hSPddUKw==
Date: Thu, 19 Mar 2026 13:12:41 -0700
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net, serge@hallyn.com,
	Martin Uecker <uecker@tugraz.at>, linux-mm@kvack.org
Subject: Re: kalloc_objs() may not be as safe as it seems
Message-ID: <202603191308.ED08BC65B2@keescook>
References: <abhGS0n_RsUG97Ni@devuan>
 <202603171402.B2BD1B1@keescook>
 <abnGea5Qwp3VYDda@devuan>
 <abrRMnxzCKEuhnrS@devuan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abrRMnxzCKEuhnrS@devuan>
X-Rspamd-Queue-Id: CDBD140007
X-Stat-Signature: xu7m7ik7kcaz3hyppf3kfgfdzdt3txa3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773951162-9069
X-HE-Meta: U2FsdGVkX19DZaeL28+Kb8gz9TjI4QZasktw0TFrw8tLbS4j3ompaDL1KZnVcFMK2POP8bGPhIzHI9nDz7p7euLKQh+udOyrzGrF6QTFHNpL+tPbVfqJQDm12tYM4cvLvJVO1Egnb1g6oxru4+fUAIf69h4Z2VAct//l6NyLSAiSvoMAXwpiV1GJAZ6DNAzm7iXwZiH3BDnqPLfh+XJFWpHe0VD7xKlKyf4JnJYyLRR37KOU9PeAl304TmKGl+9SBKHxCVVfciaZmt5IvuQkA/lBmJBfw4t3rjM0G+y9uwjyia/qQ6MjnMb2pHRRbqt3qKJ3/AwWpeJ1cusZPvGCqQC5dzzOQqIik8g2lJHQGZKdKPV+gE1lxOeuu7jjqNtBQnkxynNdCf74mq8VkMR/DoVQQqooVXcZ9RdutjLuHETC+MXjS57OJW8SzPn7kd9yX4qjxy9QMkpYoAzANcz95b2U6UjfM2mgpzelNWs4DW1RSjttXMGBU31Rf0d+CHvgShfX5FZlSuvYe6PFzW7UlRAloW9/TFvho4oC3wKdfYgEke5lVhwl0i6Qo5yHOTmpnOJeuvQ3oJqm2DZPBz8MddLyT4gWz3GqqQHuuDOYBCY2DYbfAY5SjukN8cM6T7+7Qg/iiIQJPFSbySlcUx1Trk+XB7081AHqEfkL0XYx0k9nxPJLxfQROTkyN85t2h+WCGyMCw2Ksr4aUA+mUz7wqFNRZO1Pihvu7ia55hxHB2TV06LS+Ty7Kn66tRYKTC/elYvOmQrEwTG28Euibf27g3Tkdhm5uL2Zn7F2Jn+wtemQC9NEHUrAsRqj4lZitIDqntX1IFHJMuoxnj6UH7wyVJcxdnfaq2WjUrKCjxNDMhCghbvZtE4jWMusE9E8aPhrgbAXXCV2plSlUQu6X+KgYFlvWODES5pG+2I/Jzr465YfeKSbrJZOUdGkin3OrD/wD/Zib4l/Di2dAwaS2g8
 00TzouFl
 rFpggLV3R4s+fqNT4///A7nYlbPG2en9L78Q/ltM0OBgmNvsEKUgmlGdQTr33bBJldoReSMKGwVuF2tvMyyB+rjGqt/98rCUhyFVqUk0P7vWdGoan+KF3U+IcjU2oZpqNOKGkCj8nkJFwjm/6uDlKbP4905Gk9VyogjwGQ3t7ia3aBm9oeb3C32yfO1LXeQP/5AH+9CJq6eZokrTFNIzqbqjvtctvESrGN9sUwsuhDhzF5DTIi7j9obYkFi+GaVs7RVUZ+F6sPI0qqnDs29mAFsTAegnIZBt9/nuuqUZlzLm8Ha8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 05:33:35PM +0100, Alejandro Colomar wrote:
> How about using a struct?  That's the idiomatic way of having
> incompatible types.  Since these are used through macros, it wouldn't
> change anything to users.
> 
> The macro definitions would have to change.  For example:
> 
> -#define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
> +#define GFP_NOFS	((void)0, (struct gfp){__GFP_RECLAIM | __GFP_IO})
> 
> We don't need any new language features.  This is backwards compatible
> up to C99.  And it might end up being simpler than __strict typedef.

Yeah, if we can convince the mm folks. (Added to CC.) It'd require some
kind of macro to build bits in the many places where values are or'ed
together.

> [...]
> After sleeping, I had some idea.
> 
> We could have coccinelle add typeof() around the first parameter when
> it's an expression (not a type).  Then, we could enforce that the first
> parameter is a type name.
> 
> That is:
> 
> 	 p = kmalloc_objs(int, 42);  // ok
> 	-q = kmalloc_objs(*p, 7);
> 	+q = kmalloc_objs(typeof(*p), 7);
> 
> I expect this would be doable with coccinelle.
> 
> Then, new code would be required to pass a type name.  And people could
> slowly replace the existing typeof() calls at their own pace.
> 
> What do you think?

Well, it'd serve as a visual indicator, but it's redundant (typeof() is
already used internally). Given it would only be a potential for
confusion on integral types, I'm less convinced this needs solving.

For completeness, though, this Coccinelle script:

// Options: --include-headers-for-types --all-includes --include-headers --keep-comments
virtual patch

@type_not_var depends on patch@
type TYPE;
TYPE *VAR;
identifier ALLOC =
{kmalloc_obj,kzalloc_obj,kmalloc_objs,kzalloc_objs,kmalloc_flex,kzalloc_flex};
@@

        VAR = ALLOC(
-                   *VAR
+                   TYPE
                        , ...)

Produces:

 6007 files changed, 12430 insertions(+), 11767 deletions(-)

Which is a lot of churn...

-- 
Kees Cook

