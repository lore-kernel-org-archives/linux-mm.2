Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724B7CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4CF8E008E; Fri, 24 Oct 2025 09:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7CC28E0042; Fri, 24 Oct 2025 09:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9D38E008E; Fri, 24 Oct 2025 09:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9334B8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:21:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B0C8C0EC2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:21:59 +0000 (UTC)
X-FDA: 84033070758.28.6038BE0
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C4292000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:21:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dp8GjVhz;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAQ779KA4rgqpBPvYfGfpoeCfLnfK7s3JhseOdjjejg=;
	b=FCe+rZ3NER8DrETwdlusepmQ0exVuB3BoNEvjWxJBlgBILv9PdjPhuZCJ9heyEBbVPInUi
	tGzUXI/snXWtEmi273EwoM6VsyreN9A736ZKTmaAg3hQbjPX3TgI2rX0WmC007Lbvwt3N2
	pmQOj9+MF06Brz6tQh+2nQJem5GOalU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dp8GjVhz;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312117; a=rsa-sha256;
	cv=none;
	b=2Id0+2FRk/s4an+M1TihZ0k6PX+2484zkit9V1NUB9szWYCDObwQa2LRBJbvFdLYxWu4vn
	Iu6jw/fhTJI7NsDKegtV/8/k0uoG2kMjrn85TnlDIMiiuolE6X47t5r3Cow38ee/SiYSQy
	F8RKwHSs9UXT6usWU4xkysszEgmrmuw=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-890cc9b6bbbso267756085a.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761312116; x=1761916916; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAQ779KA4rgqpBPvYfGfpoeCfLnfK7s3JhseOdjjejg=;
        b=Dp8GjVhzx1PsHeGTmNF+xUgFbKG42G0TJHM2mL+XYuA6xvF2zWOuG+RXXIdq0UpZkj
         4gfeqvlXmU9qwzBZPplPvFLQ99TBgYLqXZ6oCD8rXnUdwEvAZK+s4Lyk39cRvzG3Gg0p
         UjKXMHzannUJQA4brOemvyIhoh7iCMRlIBzF4sNzU6oPmVnBHlJHIZqkuMZbcKqquUsD
         wlcUflfaxdm4xHBdiCuWysHRjr+3Ry3ozKO33mh0/6cmNfN0alUJjWlXxTzLR6seJIBp
         B6zeBbo0KgxtELBC4z4VDktBFaVtOc3JaTMCh9o5A+cYfCjhh6rodhe/otr7Air09eXK
         lkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312116; x=1761916916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAQ779KA4rgqpBPvYfGfpoeCfLnfK7s3JhseOdjjejg=;
        b=kSlQZNYDvjlD4GuiohZ/KE46y5Dq+YsLbwBUEsfwvHW1ObI5xjzRZgzEpZnOUkvtit
         iXJFYywvh7qUHpInwSMm7EP7gsJiNmY1oj4/tcNO3nUlZWnhqPjfLxwDB7yjh8Wtzcb5
         g7vJ7HXTq6eisncl9Q08FwXinvFHU7XuaGvvMK7nv+237EGmAIpFHkMS4dagGIcrCCgw
         0VYBuRMJJ24Z4tVEsYa/36AdqLHvL8QBrOLRaawRYjuaRYwcz3u2vokrGTqihkWhPCnq
         WnDkgN5/QOVffcJfeIyQD5y6slmBAtlqQkGfqirchKPMd5mId+dske0DQ11MsOgjNWQ+
         khrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDqOtoQRPI92X6zUCbCQ5Qxst9q0XQ/Oxz4+dG8EBThU/Br8rMvRQXprAd9CBDp9ni4fjGUrPKhA==@kvack.org
X-Gm-Message-State: AOJu0Yyc66QXEIetwN0+4V99jkOQsqcGb5nQvsQJrRUBotjqpP2CrOFz
	Pp8W7woGdC1qjEZUJ7zWDJ41pvnCjf+3QKZ4Ykj9XQJkR/yoJm63rVAo7pm4Ujy/704=
X-Gm-Gg: ASbGnctjpDxw3n/46aTkpb/JOQSbFX3CeHEdYn1Azyunxm9B3/cweQvfMjQ7mKbFvQ5
	l/wkNkdEnA3nzm/5bKAWsv/Vw5QvgbppXnqylptRWSGBXaQ+C75HZTn1llGWUz2JVjXDgvSEPu9
	rWlmmSA8pLoP/e6EgZbCUK4DqE85K6Gkl/ZqwOTjkNlubor07KEgW1+8If2wDodztXR1LFGrt7O
	0+BmbqYdLDSH5FIlSqs/K/0uMNsFiWWOw8pjDh+jJe5oXaID670HPyxBNL13swVai9CMIT6kr7O
	73X3MH2WSCEI/sGsD3asWG6MaCa6kbKQ0VDwQCpIqqv4PD2yKkoWWz7UUCXo+Eagyjki5yaMzDu
	jyDFadQCPPH0RcGODSQjBo3/X/kgxeQBRaDaOJUN8fClmp4YZsAaqC2QktD9IjTicXwwlarwtXZ
	n485SBiqgHTINq5B3uCnMve902c+FEryjduZX4Ih7lnRA4Ew==
X-Google-Smtp-Source: AGHT+IF631U7b/Uv4UfsWkET0fESocT6MB8PTnMKWhD//uyVN3fsa04WJmaAsspdgQynojvxMNqoYw==
X-Received: by 2002:a05:620a:46a8:b0:890:379d:9807 with SMTP id af79cd13be357-8906fd18325mr3332613385a.41.1761312116477;
        Fri, 24 Oct 2025 06:21:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c120567b1sm384070085a.51.2025.10.24.06.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 06:21:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vCHjv-00000003hqy-1N7J;
	Fri, 24 Oct 2025 10:21:55 -0300
Date: Fri, 24 Oct 2025 10:21:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org,
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
Message-ID: <20251024132155.GA760669@ziepe.ca>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015053121.3978358-3-pasha.tatashin@soleen.com>
X-Stat-Signature: 45p4uifcubrpdkbjimkq3hjyw5h3qwex
X-Rspamd-Queue-Id: 8C4292000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761312117-349135
X-HE-Meta: U2FsdGVkX18EtU8hDF7aLN7b5WnsZ7bhiWUPf/YJUnAfjatsc1P2BjLfkAGhCnlV9LyCqB7OeZX84ingmmq5jKjaG4JaJ533btQaq4sxfUaVKkmz6P6Opph6NSonxc5NMc0+qJdSp4PFrqJh3L9dhcFubFGR+xjdeAjJWU+KnVr4707vxksnA+e1qKIQDxlzqXcD0HantFRs9u3FQMbqiaJ2yAY8NTrM3s/3nRZOPqRDB4gna7niD7a9doW0XCXDHaVZzZMvuhLXEH8OJiDnqKKyf+gLwpvnfyaVztY+Ri9PGiGi6Yaf6sX4vNC2ndSDrOqPR9ZYcfqiDHdZ5BxdckV8DWysqNkJ0FAUJmKSzs0JL8/SR6flhZ/HTqa/o0uHEDKPC5ptMwAhoUDHgTVRgH1xmQkw4lAx8y7xPQgUSKkQOS7D1RcRAe0SGXihTJwf7fIyvSh2lEJm5zIT4a4hcOY0QNFdemH/9tBzdaGd9nr1YS7bjXWXcMgM38aKM+o4RotPLBIk0+AvQVIe3Lj6boHt8z/L2ezRtvarhZShrpNWd2WtdYR8Gc9hCebtRa9p0gv1SL/SUTPD/wFqR/WBID2qB7APzxWpNm9DYm5LB+mh2PafFIhDxLGU+oHIww96xASePem5n3+kZGlGPmybM3GFpmvjuGWJxEmqw02Zc7jzTJ1qeIjODjW4w6W4esQSOQE2UeLlGns/d2NTqug6/Vali1SS4CHqJdw5w2C5YA3uJgt+G8FGjnoGEUy19cCnt9LAhWbvCnSYuIoW6d9qmjn+snN+uPkM0rYMyIsy7Ok7PhpuIJX3isLu4ub+3NZOwnRRUTDPx75K0IeiCRl0QOSaD4lfDnSPWcLMwZGq0Qb97CTheuvvFi8cY1Cp+1QUxH6XIW8A+u6N3WMgsIbFROKqcdGUb/M+gpqINMstrNrJrmVWqTcW8l1bPVIgGIkh+7HULcT42IHigkjCVo7
 4VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 01:31:21AM -0400, Pasha Tatashin wrote:
> -	elm = kzalloc(sz, GFP_KERNEL);
> +	order = get_order(sz);
> +	elm = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);

Please add a function to allocate preservable non-scratch pages then
:\ I don't think we should be sprinkling __get_free_pages() all over
the place.

You can then add a cleanup.h for the new function and so on.

It should allocate frozen pages, accept a size_t and return a void *.

If this issue is only related to kfence then the new function could
have an if IS_ENABLED(KFENCE) and use slab when it is safe.

Jason

