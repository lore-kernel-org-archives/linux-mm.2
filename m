Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965E7CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FDE6B008A; Mon,  8 Jun 2026 09:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27E46B008C; Mon,  8 Jun 2026 09:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964666B0092; Mon,  8 Jun 2026 09:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87F1B6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:29:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 420871A0AD7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:29:12 +0000 (UTC)
X-FDA: 84856826544.10.CB006A4
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 46B31C0013
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:29:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dAKsO52F;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780925350;
	b=wkjWMVbOTUsMcj5s+mkY/7LwTEgFHi3O0/hy6DuZso8d91lzm0b0jzq41lJP47ymw8uS2n
	aFTQZM+7TS4KfE3RH2vhi9NgIRM4JeWMJR8IF8femRDGWq0FEey+Jt+LrpZy7ksjKDx3wy
	voWkGsp+4Nz5aqFJF5q6SPTtWx8ka/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dAKsO52F;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780925350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIOQhdcIWAF1YfBlwwhBIJIz3OtmjYbgnjZxpRy9+yY=;
	b=mH57fP1NCkG+7BL7/kTcrYeH2NZEJInooHindCgINfwoXBmZmfyR+DOo/3GN4nUfPHS+OL
	5hdbanPuDsAsxQxRutXHdanVonBHCHz2etEO/YgxFZNVvwAFMhoxTnIqHX5JhztqbKtYeq
	I58DFkXEYYhDZUNb2U7xQwbrsmYZMH4=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso35335825e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 06:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780925348; x=1781530148; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RIOQhdcIWAF1YfBlwwhBIJIz3OtmjYbgnjZxpRy9+yY=;
        b=dAKsO52FqPJ7LMXM+tjPU1mxTaRauayHHSj4f9B7T3nhJsAG/hPxBmh9vFT8zleKN6
         YU6lhaYzZNUO6/unUQ99LM+Dym54XbQZ7yahe5MxdUU83K/j1YQhd9Z5MoT8pa4cxLCh
         47MlafI3ApRJkFPXAb/Ty8VZh3FJU+SFXLI98mk8jJae2qgJr3cos3Y9HMAUQZRD8Lcb
         AHMPXL87xC4y7OmFVD4muSPIfbKWYZYeyPiz/n0GIfq2klGvPqJIFtLGu5BX8FaUAjBo
         duQWF1xvOTulifdOUwgdwrrvIOqpkDAtlIc1NcMcyuaq9AtHsrj3PeZZyRDEUEWYsOtU
         Os/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780925348; x=1781530148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RIOQhdcIWAF1YfBlwwhBIJIz3OtmjYbgnjZxpRy9+yY=;
        b=QzBHnKoQPzXUtl1gmMoFivUayBBew/+8oAJR0ry7u6F9ixmlLir+SUxl+q9uxXFhcf
         2G5Bto0rhQo0C7ZDB8HUZy7dUacBjxv6zLrF9gMM8QNNgIH2hE2ryvSVfqA+oz6B3+z8
         u6I14CHCS+Gy6paePDow16yEoOSfybaNYGDr1xJD79mBlEYNSFlZ1TeC7HVazXI7QQfE
         oOYu/JXJPv/f6bIuuTlpMoeBeb/N/e7+mRl+WiO0S3br3xTT2UdgUEQYUY/MKbiASpbp
         9Jem3yWS0GRi1GJP8QggY3tHX11RTHmMGlAE1XgIP3vML0FNV9/BaCLAieTIhIfp6jmf
         8d+A==
X-Forwarded-Encrypted: i=1; AFNElJ8bybz4Zcjx4wTOVnOkcIohCLGVaO7fd1G1IwOoJzGqPvLB+27fTX91i3BzoewkR3w7EEVNGZ0hcQ==@kvack.org
X-Gm-Message-State: AOJu0YzGdxFNZXZvn8UFN+SgcoepDxwkLjvzm062t+LLu3lp4ErWNP1U
	LxML7fs8vjeHS+q0ceekcGcq4QfFz5XJwh6csJnQuSltO4zLavIINwTFnTl28ppMYRE=
X-Gm-Gg: Acq92OEJEGc5VViuTV9EKLct9PxR5eSIh9nRyuk7p1ni05i4bewhTHcwMLPJomC2O9I
	zqPfW2c98xZ/xhR0STEbn6hBh7zcJ09PlMm9Uqzyo501hnu6VvWYElI3SEzFTft8MybqvYaiLrK
	fI2uC/IfggSQWkh+APEZyql7HeJXOvSJSISDDmoQ8j4unjHlKGirbFxr1vZOX0QUsm2XrBxkaDZ
	vEMI7GvdqR2pNcfn5J6wN7/g4AMlGspAAFLu4RLA3+xthDQws0mPu9pEf1ENVarB8qyZNBlkNp4
	ySMQyewdYTaDAICnAQZkrdZMFWvJ+W3dCO2kNWWpvbk0Qxyrget+pHMlKRJHnVLD2DHfR8D/2H8
	mOdkYBPJC9Tz3tGAsI3SUZvLHyr7geP4WoTAxSCBcoZBfc6GFHKHkFAIhdgHfrsFNqQJzA/+f2e
	BWBZrKTHr7eTJF8/TqeX2ZNh3bclr7Q3C377FabKY5LNLDmZE=
X-Received: by 2002:a05:600c:1c1e:b0:490:44eb:c1e0 with SMTP id 5b1f17b1804b1-490c26056a4mr274307955e9.21.1780925348589;
        Mon, 08 Jun 2026 06:29:08 -0700 (PDT)
Received: from localhost (109-81-90-161.rct.o2.cz. [109.81.90.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d2d11asm337684075e9.1.2026.06.08.06.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 06:29:08 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:29:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol-v1: use nofail allocations for soft limit
 trees
Message-ID: <aibDo_pYN8FaGSgU@tiehlicka>
References: <20260608063644.39-1-ruoyuw560@gmail.com>
 <aiZ3EZZV6LqsTxQM@tiehlicka>
 <CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK_7xqyyDqNW1+puMSp2LzxmOKxFUx-UO9uGiDKoL7ZTJ8+3ZQ@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46B31C0013
X-Rspam-User: 
X-Stat-Signature: fogmirbt9ozu9iuj9i7s7iojigkpz5fu
X-HE-Tag: 1780925350-184654
X-HE-Meta: U2FsdGVkX19wQD01wu8YOCsyhLBpCv2KoGWarOh7dPba/ODr7+UUG2TYc2aN3U+YSG6KVYtS1W1AR04PCXVqeOFAfAQUKbLRmRIxjuTqiR0kH4JD3HExrRRtghE/FF/9ErprqoWng800yNGhhe/ulv1b40c4qI8aYx6WEtGKVrfWjQKD099wPAf7CGOy90CYjY3m9tAFPj3r8Q0RxidYUkZyxVO8FLqTNKtwjUJ52zSvQsHXwjpa75ekLeeq/M+8xT1TrN4daa7yFiIOq62Q8IE573S7qyeO7YZaJc/CoGQfas1xxb3xuCn+NNhT2Ysho+1CJtMFgCQ83wrdHiALWNQ92niVj+Ceha/2dZW95Uv1WSl2JHUtSbQhPq+Cuq6aYHnXAJc/gp20FUfh5OeAcQt+EzP+P+b1iWbeJWnZNzlKviUTy1SV2Uiwy8w0Lu9MlS9xs+EAtoFJ7cbtp0eZRyDuuwxWBwoM7lDgujo2RE0B/zgvGw5Kf49IsyDNxsNNg7qonFVrucY0CE/NMP+AiblZQNYfUaTty6Pd9E7B8TBKXw94l8jqupn5EQk6HK6tgYVoa5TKfg+j8l59zmw/aS/Lo/YvAOHT6/k780V93jU9CSW+EOx5H3haTVXfU0liS7ab5XsCFVl4QTFiqmyicdyAsLwwiZgk8g0eupwC/FpoC37uSMuHDte22orH7J8gv0Kl17ScSGgL0X+EzW0/OIKCZsQd659ZyC54IWaqEmL+gk98VvmAPhukqAt3kSoH1zjBVlo9wgzxPhTGhXgiqhhY3Fpn3LQSgJp69sj2b7IHKgU119/iFBOWkD7tFj72QmH7tnXFs/PhxmN4A4Cp6H741LLcXDyZO9Vam+28p3I2jOruY2/DrW6FkhKzdrws5zoIOqK1eL285Iee5aiRwzBQFD/NcWSI9QtBBOpA1cfLNTxPNkWEMGbmSFFXohCGp77jI4FqPy+JLuJ/ZMf
 RcLCANp0
 JHxkd9Jg7fiigh1ANKyIeD4jBx59TvNUgEn1DXXaNVtwb3Bld6VZqNGI2BKvBcoRmH8QKG4tCL15aQ265OxCC66M57HCcu3fXG/9bL02EY9PR7WmghmOLQajKMmVquv8v5k2FG7x4BQM4VbPgpnCb0gquU1I5lGV2VTCSKfKMXz1f2GRCD8AHdU+WPhyjtxG8hKzMxJHl1Ws2weWlB82sUCZHRfAtcUfhqg2BXSbAkV3XNSRRNVEdl9x9V2PekVQjEQjqSpu4Y6HgnUR/WojzyWkqpEV85OzBLVikZowifw2gjmlF44yLcy4sEz09anPpo0USESsBjj1/7YjGW0U9o9ESVkqoPV/P6+ZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-06-26 16:34:48, Ruoyu Wang wrote:
> No, I have not observed this allocation failing in practice.
> 
> This was found by static analysis and then checked by reading the code:
> memcg1_init() dereferences rtpn unconditionally after kzalloc_node(). I
> treated the soft-limit tree as mandatory memcg v1 init state and used
> __GFP_NOFAIL because continuing without it would not be useful.

This should have been part of the changelog because it provides an
insight into how have you reached your conclusion.

> I agree this is early boot init code, and I do not have a
> runtime failure report or fault-injection reproduction for it. If such
> allocations are considered not worth handling in this path, feel
> free to drop the patch.

Yes, there is simply no point in handling these failures because early
allocation failure like this one would very likely lead to massive
failure before userspace is brought up anyway so there is no practical
way to trigger the NULL ptr.

-- 
Michal Hocko
SUSE Labs

