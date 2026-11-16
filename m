Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F52606A8AC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=BJawmDQS
Received: by kanga.kvack.org (Postfix)
	id 608F06B05B6; Mon, 16 Nov 2026 14:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA3C6B05B7; Mon, 16 Nov 2026 14:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9DC6B05B8; Mon, 16 Nov 2026 14:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 226BF6B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:44:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1EF5140156
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:44:46 +0000 (UTC)
X-FDA: 85442009772.27.4978BAA
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7914540003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:44:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=BJawmDQS;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794858284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
	b=GQBxUzrx4rd6vqGheBcx++darThn2bZxZuL/Wvw9izs5VxToxridv3Fyb0Uq7onV/EW/ps
	2sneGOZoRfGmxvD7+8gctHDtc4V+ShgjTHZTcpVCGx0zGxWDjXyuDXJpNqXrG1if51KerU
	4N39n/O9dxEiTaU8SRwvdZA1ixEmsq0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=BJawmDQS;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794858284;
	b=Me08omdzc7mcKPWWa6YdBtzCypAQUkLwCkMlpAis71nAqqPK++e91cJUTXMVYXgIPT/ERq
	O6myvffvW3jFZdS8UBygnufuKXiCXe74jBGMSeNPGT1MBlLRVDgN0c8OQgtwC53pod84Cu
	cdCGs5XgkkmOa+ScZmMuup5A9tOE/8Q=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so374162966b.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794858283; x=1795463083; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
        b=BJawmDQSSlP7UjrAW4U92y0bBwwWagp7KNBePn5D8tnI+SeU3CTd1nQ4Hxpx3Bhm6P
         A7LuNmJnXYgcms5JMpj7qmTGjgjliuHCyNPNqKaEFEHpshlprnGvbs1GXgem8iVLrpt8
         eilfp3XRqCTFdRINjCHHJhxHZFhHzkVAlyhFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858283; x=1795463083;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nh4pWMvkRsPEst/kCwIp1wxFa2k7tAfx6b5lfGN0krQ=;
        b=HAMDuMAyYslJX1nskVZKs33H2cRnfqiQAnwm/StaawLw3QR/kYLKzTaTX3M/NH3P3u
         hi9lrpjyqqLLE1ukEQy9Xj5StGdn2SnpXvsXOESsawcnzsCUesUClr6///euwsJOh97i
         bf/4gQ8A3qZuLQrtkvpBG2FyQJh/YuxvvPZFV1bA74Izj7C8h//JkSlZoT3W4YRkv1AT
         LhY5MQ09KwMvWSGgEiNVOqdNiprpWNggD3WnwVhwl/vM7P5CrO7cG3M0jiCEqLMxD39f
         +cb6Ezc/xnxOhFbDLN2xMwqkV6nrguCtIT01Gnqf2H2cmzJgHEkFEerA1we55iLZOSKs
         h+ow==
X-Forwarded-Encrypted: i=1; AL+hErGDPY4mhM3UVnraVzut/2xN7b2e2dVe6+o35FDSPznspOCayTVKJGPCmQeiWp8xa4zXC0jJwqBNzQ==@kvack.org
X-Gm-Message-State: APuU4Z+KQEGawLQYdXOF1QBNSoVc/2UVmJnmVBZv4tAHq4drcFGyjf0V
	xGaEsvw1RRszBATK3Oo3c4XsCYWhYK9CVkBAMXoGbhYIGGQT89kgEDdwW/8MJ8kJUbJCbnr4CuC
	6Tlw+TREMOg==
X-Gm-Gg: AYBFou3WIbSHpu+uqVVC61T3uUD6loPaR2zzUDGZ9KJyW9fpNnFwPKFhSQA8Y51eazd
	lXraNvda+LeVbJpgrFUCcw+aU1Wp/vQbxb7mGJHQm+/BPge0XNvWsz1s63mf3RfBhsFfJxeC5Tb
	vqIkvZ23FmDVcHkML7Exsx7fhl1uqapahUrwnlYj+IXqIakgpu+Qn6d4uglTqot7OuMJV6VjycI
	HTqrozxdYcf2mEA5a+NGBOjBqvhSl7Too+CUs+Ja+F0t0NtmSl7c8fpvqt1pPylaL80An7a8TWq
	K31HWf/wuYW1kae1pY9JpcMZOF120HKWKbIXSmlcerwYrbkulmOKURWAGgDBq4I4/86U1s+ounm
	li5qqRDip37V53+tZXhJmKsS9Y/6Xvaso6vnWGyItvuvqb8HIGrkneZJV+I3B9oH/Wl6+kEJ203
	+c5E8RJArWx1PWpX5sooTZ3kbmlRMm4K2fwyTmVq0vow2FO2UaiDk6JHo/dd8fj7SFficVEIi4Y
	mPzkRuDJdav0Edv/h9/j17bnG0OMsgAaRbdIvyHeGuZRdWzfoA378qWITM+kAwbeG+YFcNizfLk
	fVg+oG7J28o99HLElP78cH2tGGeJXGLJQEyDm9u/ZSoxyCor/GNDZcN2WkCSiSW5pUMjrhcoJdr
	d8MU=
X-Received: by 2002:a17:907:980b:b0:c29:f5d8:9c73 with SMTP id a640c23a62f3a-c50963daba3mr1010867466b.34.1794858283023;
        Mon, 16 Nov 2026 11:44:43 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b58981sm458572566b.45.2026.11.16.11.44.42
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:44:42 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4cdc606b47so673476666b.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:44:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEzKcIL+MDK2au3b6wcT/6tIeqLm5xFnkrTnEgTF7U1ZEXpasFaxJTaWmRW3KnBe73gQ9KvQJdobA==@kvack.org
X-Received: by 2002:a17:907:d86:b0:c50:4b6e:329 with SMTP id
 a640c23a62f3a-c5096372173mr926077766b.15.1794857808907; Mon, 16 Nov 2026
 11:36:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org> <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
In-Reply-To: <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Nov 2026 11:36:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
X-Gm-Features: AclHuK9wFvPLbk2hT2Jt-YCf9KvKeXcURMdq1CAih03odFDrPYf2QaCfvYcr5qU
Message-ID: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7914540003
X-Stat-Signature: deos6o7u4xnxbsn8uc4453anwd595d65
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794858284-65741
X-HE-Meta: U2FsdGVkX18PjcOqcb9zkYWTlTJ9QFLgo3ZCDXugvZD+Xu5azVg6Y6iQSHSCXFSywPh5h/VelVMV+lHmB81b6FmrR4shuLmaWxY8psHnM09o91q/6k0/pw0rJHnn04RJf/YV2Pj+74BtnSfL4WVHVBwAFxWPkR+d56BVs8PwIyFTRLZsLeJDkmMYTynDmQnUg2MOxm8UjMmHg/c/B1FKejUYyyyN3DKeUz/gwNoVcIhR88vpYyu5ZS70muFX7EXcr5kfJKGYrm9GJHhdg1sMTU3M6HdKGuRgphHSR8y1Dx23xa4qEUS7Y+KItBuIih2vsYgIBgHLGFtLrvIR3W63V/ZAFqBdzWVTtc6Zk0u93aMp1BItUylbJk0gQ3sR+ZFrBLp1kJppEkITgZsq6pGR3GxtjleDPWxu8yymovZLcfclalqr6B3NqIB3nu5QVDLgt8XWRa+qQZh6YUyTL5IYmEFcLw1w1JPS0YdaM9LRtqFvBfXwccS5NoNpTL9f6RGc96P2FVdsCyqMFZaKYYnPEMhNZPTD0YYtT80gNG1XkKR0jnlOp3krbQq4b4hA/P+I4wRwryQNe2HELlG62Lo6z0D45ZEPcdHs96wOuu3DZeIJG2M8bRxYnIcOyHSeGkb/ccJkmQ0DLbW7YpLSeszJV1/wKIAAMTEOwinyq5F4+7PRXkRzys8va2DeKpr9J1hPgeCKrflPTUVaN2TAniprzcK2pmIXwAYpI2CeUk2mHoivkMK19Yo7KjkOiWsTI2K1VXpGUP5s4oCL9rixvhA59GOPeEuk/x+oA5l9dwTgyvbO4tl3W3olougONNlNxvKog6irAEdGXtP7yhUm5F0s/vOLQ4DxXeuUu0iTwKTQY+D0MUoMeAPmfQt4UMsgiCUhtBDhvunhKPQdug5yBWx/5+kEolMBhiJHgu9eXfMyz6SbKgfCDY1nvfa2P51WgIbhk7pIsAFe24LHDW1Oj43
 lK5IWKpo
 Ny56TIAbvN6QJ07VEo88xc/WSHZTRTmk1tvyzQD5qYuPNrF6tb3CCQEmKWMepsSPh91IhZKXAWSwOVFVMFiue3MHT36TzUK27pWWWyPETgoPw6uyzbkwJAn3dvVzzKhIpP4uECtAszWwqMVOSiZ6j6Z2s/OMPKV9VkGK0AhYMd1z0G2tw1BPkqdhFrkPSiSQE9JfZrinqLouxHPc9Nuq9S9QlYi89BIC/Vgl0DygJqR8nMCWBwMpPnkDgDedn/Brjd7UbSNXP3awKhSWS+26Ilo0fA3OxJECc99n4Fvh0gj7Qyoj90O87Rw6Qaa8bEt6R7n7xZdLiIfe9lvKxlcntqv/ePBy0DLKCzIDF4tS3pnbO9MJ7NLO+GozIfTCo3F2wzRcmOAWHDcPEAhwiVRHa6iuEyQSl3ixffCqBjwQFm24NuE3mDDyJo9hCLzXYyTQFp27e6hOdO3irax63mr99qCLcs/4dQ9bH/e3h7wGVoBaCHNCyAZKNCQseFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 at 10:14, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> Ping?

So honestly, I really don't like it. I don't think *any* of this
should be inside the kernel. I don't think the in-kernel side helps at
all: the comments are too big, nobody will read them, and the whole -
and only - real use of them would be outside validation, not at
run-time.

IOW, I see only downsides to polluting the kernel source code with
comments that aren't useful to humans.

If this was a spec that is maintained in some automated format - not
in C comments in source files that aren't useful as comments anyway
purely inside something like tools/kernel-api/ (or Documentation, or
even an outside repository entirely), together with the scripts to
then validate it, that would be one thing.

But polluting source code with huge comments that aren't for humans is
right out. Particularly when it clearly is a "first step" and the
intent is to make those comments bigger and more extended in the
future.

And I see *no* upside to any /sys/kernel/debug/kapi interface. Nobody
cares, and any excuse to make it dynamic ("We might update the API in
the future") is actually the complete opposite of the whole point of a
stable API and not something I want to make easier or support in any
way what-so-ever.

So all of the in-kernel side to me looks like actively detrimental to
the whole idea.

What I think *can* work is an external spec that is written so that
tools (read: AI) can actually then verify it against kernel sources,
and that can be used to also drive automated testing. But putting any
of it inside the kernel is bad.

                  Linus

