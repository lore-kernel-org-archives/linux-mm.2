Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB550FEC0FC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58EA6B0005; Tue, 24 Mar 2026 17:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09B76B0088; Tue, 24 Mar 2026 17:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8876B008A; Tue, 24 Mar 2026 17:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9AC6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:15:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CF24E0366
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:15:44 +0000 (UTC)
X-FDA: 84582213408.07.4DAAFE1
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DECF8000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:15:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ultC5i+S;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ultC5i+S;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774386942; a=rsa-sha256;
	cv=none;
	b=Lb4Q1nod/qDPmM/UMlVEo6c3s5ciExwFVMDIcsWwxc5djr64dbbbiKL+o2yGUJHuXS7X2N
	4jYNkyKZW2WHlGT1fcJwpFtrLxESgyMk2HZiHKsEMuKaVui6SMcqnnT2F8EPzo+KBTOFeN
	7f2oZOgZBodaeXKwQtIQwe0QI7IR6ck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774386942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLDhxrVQ3JPNzGwHxdK1b/M6GFU5OnGRZQ4Lon9SeW4=;
	b=dRdFfrRXNY21IJjrbHar5foiyMHqqs8O3HKVCZsHtYc7049smIom8y/vdn+iHNqpHGgTtO
	ofqJxEbca5XpT5D6OV5oZoylqIzhHfUJb/zlAOJvUHDMV98TclVaw+3DK/IiZaCUukqf++
	6UION4x94dD7mmtaMrEJiHCQqWH2MAU=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35b97ed057cso2764953a91.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774386941; x=1774991741; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLDhxrVQ3JPNzGwHxdK1b/M6GFU5OnGRZQ4Lon9SeW4=;
        b=ultC5i+STKSYITWs4EYSVKwZ6cyKjBIUL50HdfaYVuKBnzv4aaexNNCLIj8oA1bkwn
         zdRRQGdigpHYPXiI7bSxAMQS6Na2OBeS0XLCXuwfbhopyf581mL+jZkUMj3cnNoB/qjJ
         opl/bfbanwQF79OApogKKpX3OMLYlVCY/MdqqPlZrVH8QP61VcBxEtS9z4rLtezvtA6K
         dxqV6I+yu8HLKhBl27pnNULh5BHiUYflv+UzDtTvLzbThBCIgfGnqJs/iKobhL8kLXQc
         Iye35FV2nwrfIJY5Y6iUPssFt+Ee15zqX/+XCqYM/hGuJaTBnA+ALiop71+wP4NxnrFp
         eoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774386941; x=1774991741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MLDhxrVQ3JPNzGwHxdK1b/M6GFU5OnGRZQ4Lon9SeW4=;
        b=UEW3Rd2BDumFazlyHoHda5EYeBSprhXpDvNNbfz+xyu+CmOEVoIXRpTfR0VKu86zTO
         Lz8ee3fHSCgjI2kmi+1sQGmrzR52A/fMLIa2akTNmdUTSBReA0xXkaP7DXLNtFdgkTHM
         9//DvK+X1sLSa3j5swzSp3bTsGFmRY2qWw7Qso9mpRgSuk9D5IEZaLSiOqEFLOqOJXu8
         vQE7GhuvF2gXmeiN3+/IsAp+kGZ3hi+LDBN6fSnW7YzdtucZkN5jwqbZ0uhejLAjIOKk
         NCUoMt4y0mpAp4hISpB21nc43I/oDvJOJfL3yXd9f2R2inQKK8XjNLORlJYMiQDYoJ8I
         Tjzg==
X-Forwarded-Encrypted: i=1; AJvYcCU7thAaI83Iekvjem4SqVKtK+AtLQa7QMLwv/PEseGLe1HwrGxBM4z60epabsDhF7g3Q7DloO8Q+g==@kvack.org
X-Gm-Message-State: AOJu0Yzzyl00o+VZP4DEzGhQId0PiVVmp3v+89jIs1ZkKWlvzW4kYXmP
	ElHti0CNwfMYjzol8vSp1flacgOFaVHMdACLCwnTefLAu8+BqlUpsWWstT54/GvI2w==
X-Gm-Gg: ATEYQzxfKQXo7WbrNEF8mbgYRbcStbvTmXrbo7KWVNlWjFMGQuQPuGVLCfQxOyF8EEb
	pTwA0ZpLaFc6zQVc9LelR8m7BSZEnlh5CvZljS2asFEoe1lMARGmce3+90EX11xrUwugW56Rnu5
	KbA2TZfCx8S1zuaTIHGBTnu1jK6exo934265V33Epm35Q2PC4CJLsd/lK8Kebjtg9zAMmdYdRqx
	6piv4tpsakGWYA8GX2hvuF1Ix2nPzVe+0d40OZ98kFqRiWhFImYAQldhBvs9AJlVrQItRFGW8ri
	iJxg23IDbWvXhoCQUkaD1Vw8tY2YJDzeFeNs6i6znxH5X+d7DmlDCA2pPu7/nx9HPQmZmy8zWSl
	4/wHm0a5z+5WCTOdL4t3+9ZSXKiimSg6NJaIJE9jmDY3CsrQUl9igsNuB3GQeb3I8ZyTca0DKxt
	LkZmUv3h8Xh3XHfbeDlLa1SpdxtD8jNfahb12UGoTmcW2G9U9yAQ3IL50qFfIJF6zoFrR4A9Ii
X-Received: by 2002:a17:90b:1647:b0:35b:9958:4edd with SMTP id 98e67ed59e1d1-35c0ddb0222mr711393a91.30.1774386940708;
        Tue, 24 Mar 2026 14:15:40 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0312f1a5sm3248479a91.3.2026.03.24.14.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 14:15:39 -0700 (PDT)
Date: Tue, 24 Mar 2026 21:15:35 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratyush@kernel.org
Subject: Re: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
Message-ID: <acL-96VeL3rAPbgo@google.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-13-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318141637.1870220-13-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DECF8000E
X-Stat-Signature: 5mcg966fduzqizzyzc5codf1d7gnx3a6
X-Rspam-User: 
X-HE-Tag: 1774386942-392279
X-HE-Meta: U2FsdGVkX1+vJluhycUuWjmH04m4Y0dlwAbMZOm6naQz12lC6iDAeArJRa3nhJ4v4wAulGvQuKcYqv9/kn6P1g1fqgQmF+cebrYpPE5etpX5M+p0rOBcEJrTJzReTs+HtngGTWhep4PBtd25qrdFALUeZwvr1nbV4tZZr/zUXiqWi/yIxxvBxWtrp9SIF5QLHg+RpvoQyLM/baV/lK6MFMVKRWvfyHJQ1bX6aCDltm781IWAwc73yNlf6maxkqCnoOBygBmw8vE7IxJxz4J9h7TEaP+m/2CRob4qbRaBT0Y/VTzIgbciiMmjn2M6/c7/oUCNevzhdA+tvh+bs25GvDrW6hpFxQw9u91LRLy+ZDGd3djzMXbOJYhM9OxNeH74PsbrrdyOO6U1ygR8Eys5cGpsbkWq95G1tZQw+9pkM24I3ss/miEAVyVzEQnbPBEuU73YbqDko8jlSWf61Aq6OY55kng5Uyk2goxrJ/RQc7dk8Y8FppAwnc0Vp+ikAs78fBfk/d1uWezRw1YX28DhGEuGnFKzFvi3K9HoVAQV6mVVJ1k4ntFHtlk4mAmRlV94S33HkmOxz00xVPvxJqfu/FvJoJ9mRVZZ0f/h1YmErFZZ01Kv9L2zPHVpE8DsyiA2K6lscJ/b7KsKGqVDgeajh8SnHVj2jj9H/Ml5DyAy+BvBby/Ad8Vs6QPJ7QtLRiSvAYO6enOQ1ylMaWMygVxP9MVM4ET43aURyY3yLyoRwRp7sy/PbNLiltwo7zS+D3PLTtcjyjDFy+jlyQbqyW1JiXlrG3Bxetm1lXLDJFLlk+VCWt3webXA9RaG1J2Hq0D1J7+kaFFG9jFL1LlcMDMETigZvnWBZcprU2qPyTjH6yNiIE8KQigxQ9wyeq+qDJwCbF2bcfaGIvDHMK26xVRN8e5iUTiE7KXuBCH11vKFpc6k4PfNipdsI0XzNSOB2wE1g1StLo5fFYG1vwn+qYP
 GcSjZZzz
 B90nOfDzqCpfnWp17FW18Ake4JabSFzFFLrjZRjUI2BHTWIuBQx5zWkj+f0lq4A4UmXHT6N7AjF3nWvOeki8C6tzPsNBUfAtEYbO31OWdGSqEB+KX8lJrxm7sjO9TtgYSNpDW0rFT3+wmLvWrLS40IgoFa01Ummv/BqsQXis5x0e39asG1Frt65JjWLcbRnJoRhOjGd4cjzdVSBu/fxycndA0u56eN34WxN4kkSZlgigkesEBUN8/m0wha9OD0XBp/3wsgTstWjUhgj787UeaiXlWO4OP0too7Ns9eyQ7Ymgbjh95NqM/EdoAnjpcSMSuQITdNO+uo/ZClydB0AEn/ksC1J6WMXln1qZyM/jiEcgpf3xrr/AZozm/R/9cXUsaCIneT3JoX5P2NTayynEhaWVHaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-18 10:16 AM, Pasha Tatashin wrote:
> File handlers do not need to pin modules indefinitely or during active
> live update sessions. The VFS 'struct file' pins the file handler's module
> via f_op->owner during active sessions, making dynamic reference counting
> unnecessary for handlers.
> 
> When a file is preserved, the live update core obtains a 'struct file'
> via fdget(). As long as the file is kept open within the live update
> session, the module is pinned by the VFS and cannot be unloaded.
> 
> Similarly, during deserialization, file handlers are matched based on
> the compatible string. Because the handler list is protected by
> luo_file_handler_lock, there is no race that requires dynamic
> module refcounting.

Sashiko found a potential bug here when reviewing my VFIO patch series:

. If luo_file_deserialize() reconstructs preserved file structures and
. assigns the handler to luo_file->fh without calling try_module_get()
. to lock the module in memory, could the module be unloaded before the
. file descriptor is actually retrieved?
.
. This would cause liveupdate_unregister_file_handler() to run on module exit.
. If userspace subsequently calls luo_retrieve_file(), could it result
. in a use-after-free by dereferencing the dangling luo_file->fh->ops pointer?

https://sashiko.dev/#/patchset/20260323235817.1960573-1-dmatlack%40google.com?patch=7973

I think LUO would need to take a module reference in
luo_file_deserialize() and drop it once the file is retrieved. At that
point LUO can rely on the file's reference to the module to keep it from
being unloaded while LUO still has references to it.

