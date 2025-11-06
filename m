Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F004CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 00:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A265D8E0009; Wed,  5 Nov 2025 19:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFFB8E0003; Wed,  5 Nov 2025 19:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89ED88E0009; Wed,  5 Nov 2025 19:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 754918E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:00:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 394664B451
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:00:25 +0000 (UTC)
X-FDA: 84078225210.30.47938A7
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 511B340010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:00:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KI5XhK/X";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762387223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xdi2SbNzBRTUXMlj2tQpqfAaio37iPV8pPO566c4vYQ=;
	b=QsP/Q1JTMRI5hdkyB+Fe01gznWOcACFJxKDm9IxlFFBqoTQZjlV0kPVwtY++A+iFZll7UJ
	w1GHtM3C6UlyGD2kuphkRyDQgJ8JBasExPrFWNJ0/rQzoKqi0ZKxN5Wsprh5i8kp/Jnk7H
	Z1mR2qCkEDukWDW46NCuAJ6KslbHWZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762387223; a=rsa-sha256;
	cv=none;
	b=voe3FREhJqs16BerdBJFwPldo+IJGxqzQRYg073oYQxmAx8W3KFsK70pJR9Yb03fvUr/nE
	ie+Apa5kw3FdLIvI8F7NpvZdxl59/a5JicJbvPjxgOhn8jHU0fa+xdFi9QRJ6ztDSFGNaQ
	5IMd9p7X8EGNjv8HBIriSTrmVHfl6iI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KI5XhK/X";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-341988c720aso345145a91.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 16:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762387222; x=1762992022; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xdi2SbNzBRTUXMlj2tQpqfAaio37iPV8pPO566c4vYQ=;
        b=KI5XhK/XZV2NBISxCnYbd3LBs5HKktFb11z63yxaKQChpOI+rzb+B/eqD328tpsYfQ
         EieAq+a3lk+bKV7PQrDGQMx2eC836SbBEeMwLw5g14VIbjdu0C2Pd9rU6aVM+vGK7wjo
         DP44Iv1/bRKZjKymEagqVDqEuggt8PLh3kHLNcIHt5NUpOTTi/iq7VQOwrZU31X+NuDB
         TtE6sx+Hi85/JBSbLHwqB/b7GxZ83z/6hTHcetbwhl1lQ9qjudO/byoySnpWV1NaMNsA
         ClfGg8YKksrSe5nznrT7CYyL2fIqrEM7w0sBdt98UD5tsV+X7qHkueV/Zs6hQ91tNbYX
         Mumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762387222; x=1762992022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xdi2SbNzBRTUXMlj2tQpqfAaio37iPV8pPO566c4vYQ=;
        b=Q7VkfbTDYEo6YCz5ukSodZA0Ae0JlcgPmiIEVpMscDFxfjKlWhkX0W+nydtS9HX0mq
         CJn2hghmJYiZ7WMhU1sprcsCLxbnNrKC4QC8ecz6x1J+OeHZjpYzmy3R9MZES00R7mi3
         QANFiDkCHjdMy/lEBSMNgN3CQM704t45AJMJGZr1wb3BvqD29rLye3qhUS0DeDkKUOzB
         +Qa2BmOTrGn9n8EAlQA4+HqN7LGzXmnoRD0uPdvkVmZs0igVbNmZXRMpIoH6KgYDSvkx
         u3qhb8vuSbGhkDuXt+I5XXcPzpv/cYNhs52/gJWjSYKjzIOAmGDNqCaWq3OwCiKLaiQw
         mGLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEymtLLF8/OiTVuqroGV4w0dccd9cEaTkk8DMWctsoTspMVZ5I/MvMPIZDJiyIe4mMMKYz+JzKNg==@kvack.org
X-Gm-Message-State: AOJu0YzGHtWtM5Z+qTLzEtdiEu/BbDA38+ejZ8RM8RsGI+WrgHY/9kOE
	hq46ieTqhdpSkBdK4OSvE9UQGj69pW5Uo8Zi4cXXg/iupaBVy8tSPcq86x3MUr6Y
X-Gm-Gg: ASbGncvUnMhW2UbZMNHkeMozV8f+BRX61XXyk9XkibLQlhxBUU7OvUIiAJgoafin8g3
	aBuERqmebfz1uScMT1Lpeo13PD2zqaU1iSQyArXItoUdxXBW7q9XQlj6Jz79eonzIP19NJ702Mi
	uBcwJH4HV7mfCsBTIGbhrRLNBhdgflcb96TC3exwmSpXE36160Rs0R2eDpcC+U/Pl+a6YAC9q80
	RwQfs95/vW24u+FCRjSfWUaUz8NL0uAifrjHkknvomF0ufSjoGHmiCYqOSdSKJnXOZ3408oA5sf
	PKvbjRZzyUkOE+HKYaaJVGzzUtasENQbuXn43LhSysqjM70kIwoE05Kd4t1yh9kvSlbTS4rut1O
	tKQeVF+fidnF1RtHMzBzQ2Lxb72gQlSlxSD1yPze0JYQS4ld/+fzXXdZOFfT4wHJ2N0jEm9IydN
	xZ72mFHYjK5EJl49/GkqYteR4iq3KQqBCy8wCJ7k0pQQ4=
X-Google-Smtp-Source: AGHT+IHGfj9th0acpdDFjz42m74ilf/decQCNexo/5AMGZVdg/gkNfCJVX6eIBxzLZID9Xwzn+qfZg==
X-Received: by 2002:a17:90b:5824:b0:340:b152:65c0 with SMTP id 98e67ed59e1d1-341a6debc8fmr6184346a91.26.1762387221835;
        Wed, 05 Nov 2025 16:00:21 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a69b33c7sm4100865a91.18.2025.11.05.16.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:00:21 -0800 (PST)
Date: Wed, 5 Nov 2025 16:00:19 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQvlE8Hcy0uYAAmh@fedora>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
 <aQopoAj3i2jdIX6V@pc636>
 <CA+KHdyWxjqAxVEBjOun9VxoeErWEyba3OvcJveLqnRuBLk2RLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+KHdyWxjqAxVEBjOun9VxoeErWEyba3OvcJveLqnRuBLk2RLA@mail.gmail.com>
X-Stat-Signature: 3mt4mdiggon6zz9jr1d1gatfpx8qnwjm
X-Rspam-User: 
X-Rspamd-Queue-Id: 511B340010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762387223-197039
X-HE-Meta: U2FsdGVkX199fowMyMeGEYYQSygemTc6uzqc5cba8VoZezRQBV6ZzBHpreYbngZdhmLnA12DBxN8uOMPLLHSLtaBJgIMDts8g7QVAkRtPXCWrQ9Dn76/JAJNKA+GVd3M4Gqly/0u7KkwZuqyyMCSpG0gqp7MvdjMVRx9MdlD9CVro6y+x1+GDBO2wAR0hrx3DsHyfoooUmOJYypqinekGAXbqiFJHP3oPkWLp1mMqdguYL917o1dN8D1CHbip5LEWw5Q+8OJakm8OXuU/P4n4nIIsYmzO9lEFQXQnvcT7RFNnCAMkdA/gjKioUYKY2sdPeqIxD7BvEQQIwImnfGcnY4EiRFRlHwGap+/r/PxYi0AejX+Md41x5byAgKpsSxSc4U4LPYdWqD+I3AbQDRKQJbG8kxV7seVb5pb9SwjMvBbAnV9bfNOjID31xEdvADIyytjN9s52+uT0suKb6f/v1xjjEZIwq1fqpPCVI1zwOwk7hQhRZ3rE6SwO1S1oYnSfBb6A+r2fnw3842X43Ea/NNbe3SnofvhpfPamh7xGR3QsQXycYH8SG6ZOEnSxfOPniEbTndcWcabLMULmKIiDofumLWfCwL/JcFyAZ0T80oVewlJOgUwB488UV0hc23pYAeuiObgl9r4k3R1SRXnCeGv9QJvHdwPBzdKcuns6BPEd2hmoPFdvhMnHjjcastcAZ0TAHtP+Ynbqgtgq79ZCN73m0+KoiFKkUfY/6cEtW/CvpQy8quQcmFGI75mxOQYtjhquzjv94UR/cbLN/vO08MWuU+np2DZDuIojdfDvjyFC957MsNemc9mlQ1szUL+kL5z+RIbghKSBKa4CdEa+VGwjmd9lYzc5gMMaxZcMKU7RsrETlhxZajgghnjkkLCczh6OfvWBDg1auUCSGJ4hNEqHsW+JqIzWLPb9yhn5QJXu7On+NMbXC5I11iBTc+w+Ol0f+LD0AOKV5Zad2z
 FxVmHWOE
 ucDkyUnrctznk8KK3Y2nS9z1//f6ez4K9gLQ7nO2RYOkmAxQrj2zSp2ToCJSP+VjDXuaq6bNx6wC0elvv9sDsOokgs4N5/0Wz33MbD1sGZf1+NWiBcPtGlPxR82rArbJfoY43J9HBZxLcQBGqipz3I5IYftRgSD7l42EvkzbHQNkwv96EM/pqZ6cJZF1po4S4ocU+dXWxf0lfrtl8j3b1JQ7fFqDo921LUR0WcBhvRIzG5EhgENmzzmmnfEQRPek/1QUp4jwBu+gtD/T8f/OBh0P4FQr33myv3Mefw/UmDwV0Ft3B9riarpfM9f5sfT5qSXfszLsGgd5BH53xRD9+4l0OYYhiHBgrBXpEjPokxAmxJgIT6SXtEgNgPI0mW7WtTT+eSanV9GwArK7EttOb5WQ8hIsyV6G6gekTqoYEhZbvDevsWuaLpWD58d3nofgkI90anJSP1uuGK4nQ/4yMRhJWdVzWkGwcBKRddXuR+VSR73YtQ8cUBPKjXAQObrNKgfITwhQhGqaCrzDm/6y0dDBkCIt6OPEWER/vCc1gB3ZsbyEZsmumlEuvbkL+lT5x0F1KbEL3HoDML9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 02:16:24PM +0100, Uladzislau Rezki wrote:
> > On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> > > Vmalloc explicitly supports a list of flags, but we never enforce them.
> > > vmalloc has been trying to handle unsupported flags by clearing and
> > > setting flags wherever necessary. This is messy and makes the code
> > > harder to understand, when we could simply check for a supported input
> > > immediately instead.
> > >
> > > Define a helper mask and function telling callers they have passed in
> > > invalid flags, and clear those unsupported vmalloc flags.
> > >
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > ---
> > >  mm/vmalloc.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 0832f944544c..290016c7fb58 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >       return NULL;
> > >  }
> > >
> > > +/*
> > > + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > > + * This gfp lists all flags currently passed through vmalloc. Currently,
> > > + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> > > + */
> > > +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > > +                             __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> > > +
> Also we do support %GFP_NOFS and %GFP_NOIO flags.

Both of those are subsets of GFP_KERNEL, so I felt it was redundant to
add.

