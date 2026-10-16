Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32AECCCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA7D6B0088; Fri, 16 Oct 2026 10:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492006B0096; Fri, 16 Oct 2026 10:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6D66B0098; Fri, 16 Oct 2026 10:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF6F6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:48:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C50A1C3A5A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:48:09 +0000 (UTC)
X-FDA: 85328769498.26.6392CFD
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32C63180002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:48:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=QVRJcyqy;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792162087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7M0vWm7aULNLgXxZt4UuGQxMmmFksGw7QzD0jlXsto=;
	b=DQtNmeSkLngv33hV7nw0iGL+trIEV4fG2hiEqwqxW5U9wKvij0pb3Usl/H0DvRngEHNDhj
	4iJZEPnUgPuqVvyKVyvV9gq7gHuXEKskt4BR1pNGiNSfmsAwaNvCDnkX3beUJmHqFujZ7c
	9YhxHdUlx2XJmhfdiVAHLDKqUXrN7tA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792162087;
	b=FC4mFBovLoJh/3gD05Xlef7hAXP4e6iV9RNJtjm99TjionlvK7hopaY8v8gR0ru/izXPp6
	YzLuvJQahEBRtGJmQYQXN51+0Agp0tGKQV9Y4trNen4iWZHaXDs5OKHQgA+E8a0xLKPvHJ
	tCoEBJFMCEdi++Sd/dFbhRHvfFfVreE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=QVRJcyqy;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so4193103a12.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1792162085; x=1792766885; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F7M0vWm7aULNLgXxZt4UuGQxMmmFksGw7QzD0jlXsto=;
        b=QVRJcyqygoAEwJznPPKVIo3yx5XgbB+2sfN9VABFBvSxDsWBcYSzdM43i5xznlNgoV
         /oLZGkBhiVjDTeUFQR9izZpdriqQrjERaqzUpH4xlYqGi2VrfVh2hecWXsyKz7swtNf+
         X2ObTXG6PtGp8godcouE9xiu09WCoEhC7yQ8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792162085; x=1792766885;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=F7M0vWm7aULNLgXxZt4UuGQxMmmFksGw7QzD0jlXsto=;
        b=uJxpkkBXAt2Ls7SGYcPzDXgCK7bZ8neREjog1KDe9Q55yJWgLUZtaa/IjoHvO+6yLQ
         8Uy7esbDVTTaheYoOYQEblTIZ9Jo6hBEmszAVqQxQTbhRSS1h/88zaNPzfAO0hKnvXwi
         uB47oRY37DrbT+VQEnRNR+CGOamRbAe3/zMV2Xl+NMqqGe45BIl08OP/zuUCJ2Jmmlbc
         yh/+W1pQY33UzEkvPwKpN67tfSmLWFdi59EzIele9NhJhu+RdX3o+yrFmwvHwZ+/vp3P
         cf06UqAsVSYHJr7zfwu9wBIezHP1PjAVLwDqOFcHnYtMqXMqPEpd3KRamFT8yZeHgZm3
         6sUg==
X-Forwarded-Encrypted: i=1; AKwUvBxfbVtAlzGBUOBdJK3f5Z6IlbIsRpY9NGQ0ZifoAGXAN0wvdVv8QcaaxdMCYiw64LIyfDdysX5cXw==@kvack.org
X-Gm-Message-State: AFq9FYKGs84uQgItrM/U4Q7db4Wd5zlSxxdF4gX2/WL1/udbSceoLSIJ
	PJNakYiLHFRgPlUa8M12FzU9CPGD2Wp+PIcHeVtpym/DT/hxDuZchcnDemwK92djDw/+osMHw5l
	0iv94X54=
X-Gm-Gg: AYBFou1R4UK9aFkPmLeCmdSKOcCq+dr0X9b3qDW8PPCudWxdMU7LXB3WA6oMS1L8c+A
	nlxwewTAL99COZ1plAlUOhlbKf8usSR3rbJ/lWlWgwfAiR1udrG84eM7lPV7rFgweqXI2PShBSM
	iIwymaerTPGNgM/2i5l/HmKLK58WFULUXK8YNv471cOpDmSOaF20gtPyOJNQ64WXg318szH4ZhD
	Eao1tKRf5DBsun8AFUw3oCFAdmgCo2qZZaweicyoLagaJbf1BzE+UBVpJlLIM5Tn5otuxiy2VDb
	briosdqP0v8EbVEV4lgi58sJSrdlwxc6LoDwDuKMu6fk5tZqXjO3yXOntBZbx7LlbqmEpD/lsNJ
	yqJdVjB2iuQ70g59CRVCxj59Tj/YC2GqFXuCs1+qX0J8FtLanvI0B9iHqdb0d3bQk1JrZvg5WGD
	o9hxNXCdYx1aA8RJNTFBGP7PPuiEeouTM4rXOjNjBIGkbQcmQfjqU5w0jxlC7TrHXFgQgPL7Jjb
	V/xuuO1LUQcruhy+o+VkwV11LZIkfrReFe71Sh8mAL+Oxj/
X-Received: by 2002:a17:907:9605:b0:c3e:ee86:d2c with SMTP id a640c23a62f3a-c419f31c8bamr242766b.27.1792162085429;
        Fri, 16 Oct 2026 07:48:05 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40913c6145sm80458066b.41.2026.10.16.07.48.05
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 07:48:05 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso322063466b.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:48:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxaOaygHh/fEwyVRcgZaz+woK0oySEioCMb92EdJGdjbvwEcRB7uoRMddaKwxfaXY2v8tvkKI2cpg==@kvack.org
X-Received: by 2002:a17:907:2d2b:b0:c33:dbe8:291c with SMTP id
 a640c23a62f3a-c419e93b378mr2200366b.20.1792162084848; Fri, 16 Oct 2026
 07:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <atI0edrmeiRuRtNQ@thinkstation>
In-Reply-To: <atI0edrmeiRuRtNQ@thinkstation>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Oct 2026 07:47:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wha6UNEv+7nVi9zSxa4p=4K-HNMZqxMR-RcspjPTxYp6g@mail.gmail.com>
X-Gm-Features: AclHuK94Cpn1Jujqx5J8oKvkM5v_riGLMBL7QC5OrYhuF36dOCmhroOGOljhXgE
Message-ID: <CAHk-=wha6UNEv+7nVi9zSxa4p=4K-HNMZqxMR-RcspjPTxYp6g@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32C63180002
X-Rspam-User: 
X-Stat-Signature: twtdkij9ty418tb3tgjq163x61odmehn
X-HE-Tag: 1792162087-951060
X-HE-Meta: U2FsdGVkX1/tPkODHqOZbC/kC55laMYeGzhIoySqBvvuhCnC5/EriMon3dH/h077AVB+fAMYzAYcMuPZ8tCmOi19jB5fUmfoysHEYWF31zetuVixSlWW//tiuz4dDev8/X7vSuytwtDNK15erZnEBVbG/xeTSjYI/5jGK8gAOwm8Nxt/U7vQMMo0+x3flVq/LRS+IiZqIpCjz4xi8ptFwvqUtK+dPC0iEQ3e5pMOxIs5S28XhT13ERbThTVdd0YngtKXfU/y5XhMgFM93FSrIxV3hJv8IXM4u5czb1nL9oLvNbBEXWO38Bo7+9JKh64dlHp/D+HZ+GfWGoJYNou05orz0bZznbxsvygGnHX2wH2SeHwdN6i3haZziiZG3VHfZwzSJl+cc5xOOsgtyT1JAkmXkxpbGb4r4xHueqObO33NeShtIm4NrRAfrH8Ca2eld2dt6Ruw0p8w6TX0U4ltiktLFxvRCCVHpDfOZLDXq1T+E7YLBvQ/4wIFOFiiTDtzSsoD3tMJVAoiX74RIAW1gEqkR+4ai+lUlQJx6BLH8BuHFZE/F+sckYMXU8o3HCf3hTWNgDi/9QxQ2NqkLivbGlYW2WFLMBDqEZXxBv0bndj7yQIX3VeqA+n16RVwvqEPtjOUuXLQbTk14da0sd8InvI13B1CLslg++3o1VqPKmC0ZLwb0haeo55+ozsbYwe3JZVoyXx55nJC3d9AdldXsWhjwJ8YWpTEYX/GoCDcE/llP8TUvDCkL/KEM13/DdbqUsgoNsAwIiDApi8dJFqCDTHAGJMXaPMkPV/oI3UxKIX+0pvZAMMtMxFa7+UVPk9DqDuW4OnDKTNduH4aRTJcJzNE3FmMm9rCOKxzGJo1t1a8cKmjMYeblWeto3r4QiIBvlpSnqtNXUIoXwNCJSJOw8pWeivCEiH+v/HaLwe0nQGq7mUJ3WvnC4ybakvt90dXz2LrRBRxDd6Z0uZRztL
 o4U0kQrw
 nh1GrV8TFlOl4rcqwlgd6qvXg2/63HbGndGLjlCZMKg1r/k9XITsGmF+5pDigLRdfHlEaYquGUyLIEHng4Gk6uz7TKxwDCbM/LccesWZPnZZbdSe/z9+D8PJrH1QdEr4Qi1TKCqQMmbVZJ91XwDiMMHXaZs0zXohK0G6FFJjtL5+4joocOwA9SZZUDeRe6frAtCqbQP0/tTqDFW3Hv/nK/Kc+YctOYByun0pGnVRH5aUL1IQfKdTUJK6bbiO/kniy3parlQgQxZwYWAz/5o/VgFCMWorFBzqYOHR450O7dxJJ3N4WkMLAizfLmiAUn+d+tIhnNKttYlELhGxjXIiC2j8o6BlkU6DjBIh7vaa5X4/E5RfuKlLvVpVvgKHPnrO2ZK/1Tav6HbkH2pKfs2Az4JUZx4tw/s+dZ1Rq4KHyCX7RdVWsLsu/9Evu214El22xnc0K3MoAD/O3alJzOc/uQObTvJAmlFI9ww+Vr8REVqWQRTpdcOxu5GIwH4PaFKMCnWGyEO7vZylpCNXJzX9AVlcEu+yzr7VA38Dd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 at 07:40, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> I've added a cutoff to the lockless path: if the folio is large and the
> read covers more than four of its pages, leave it to the slow path,
> where one reference covers all of them.
>
> Sounds reasonable?

Sounds eminently reasonable to me.

              Linus

