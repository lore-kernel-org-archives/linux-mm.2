Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74068CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 10:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17B58E0005; Mon,  6 Oct 2025 06:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8508E0002; Mon,  6 Oct 2025 06:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE268E0005; Mon,  6 Oct 2025 06:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E30E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:06:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42251B9150
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:06:20 +0000 (UTC)
X-FDA: 83967259320.12.9852807
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B3AF120002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:06:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BllOJPaD;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759745178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdL3Gjg4YnZQbKleKeTBCKkou2FNTLhQNiPxLrTgrlE=;
	b=l+4UsXvqphthW07i3q7dHirC+gOEQcftkmmOMd+5oeJhrlwhkK1SAPniWm0lvJHh2XS+nm
	Xog1LMK9fPixCtT+wYGRbcSg5/SDn44FnRcckR4XzSf20DE0RNleSho2HXcpYa9jjPNc8V
	sUC0cwrDicYz5QjMI/uwCOF+IURN798=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BllOJPaD;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759745178; a=rsa-sha256;
	cv=none;
	b=UXFQZmcTSvGYbgqxev2LX/fGse7oVoctuO9BWTxvq2sLjn2UG4QmByZiZMy1Ot2kzZS6Vp
	DPTNdpO0XEJpBKTXtWyRAoc69DvxrXLrCyJPrQryBLIEB2Dedq/+EluQp1XYLHsjXFn35/
	yW/hNaKuJUIB9izR63zxIm6CsWQ6xIk=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57bd482dfd2so5225832e87.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 03:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759745176; x=1760349976; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qdL3Gjg4YnZQbKleKeTBCKkou2FNTLhQNiPxLrTgrlE=;
        b=BllOJPaDwhnDNIOZU6XhQbpJTJrsVR3eBRl1DJAPhcvxZzKTred+pQZFwz6UfND6ZQ
         O52O3SWpepd9QeGf+A8fsWUlkcFbWPSjlWIIoY0y/ideb9nw7wimLx8TXbkFxO+6w6q5
         lHMN8Fpp3GTZCaPeAC1Ayv7HPePxKQOY+nsXcpJkcrzualc7Z1YymTo7wRC6v+tau0Tj
         LnqBuFOF+Cwd4e5fB/4GAyI62kIugS3/Na/v7wh32SPvzmcxNQLsY2GPXJHh8FJYqA4Y
         AWEdGhznAbqsFTl2hIc0t2Q7PgvTTkH8ec4hemwApFruaPQ0lLWlrJ8TpqJVlum9LT60
         d9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759745176; x=1760349976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdL3Gjg4YnZQbKleKeTBCKkou2FNTLhQNiPxLrTgrlE=;
        b=Mp2lR9I4Toq0kAHwtzObbdlD2Sl1bks/5/vJ4E5DRLmVQAPiHFb9wKTiev8Y09JEBs
         KjYpsZ7tZl+zI4uW8rK/sE/zlp9O0bdbJh7Rz1NhlEBTA2TNBog430zKJSKtJQEdco6C
         /++SigPi6kAmNpOYD8vq8xz7+wsXoKLoBZQMEoEm85kKYcBirFkVVhxFx8AMnXNE8Otw
         FMdrHSzhZx4hSmgrXCPpbCZAZgzgyqkXgUz0JXL/Ramho9Z8vLlMG1J5fR7b35Q85/7E
         9Xr+Nb52djIE4VDQY7pB08vnvzhpux5MfuKoXBcvyvl6Js6LpDiw5VXqkCOvsR8B5htO
         UrEg==
X-Forwarded-Encrypted: i=1; AJvYcCU7LNcdJQeo3quuMjnzVnzgLZ5kaHO6SP2AVLeMuXF5Dm/Pyph7d0cSMMlSh40C2LchJLDZm3hX6g==@kvack.org
X-Gm-Message-State: AOJu0YxEqhQhh15+b278r2m+kRLNix/f/5LMFTN2CiuX6fpPP0JmBqfZ
	F8/2P1G2OMFSM3BIX/Nnz2RrYigLWpLkfwJ2rp1VvnY/sfToOWxNMOQY
X-Gm-Gg: ASbGncvqnyIgXZlbSVgQ4wMk1ndTc8C5N+BXE/PB3vE6cx3WwwhSHkuuLqZdIQjTBHC
	ERIhskQ96aY4i67npKbXq7YZpYw43hw8D0Od5Slsz94cwKxybYUCPlom/7f4KVxXLmLoW/i7mq4
	SMxjcxNJLByKtPL1p/ylGAMQ2q9waEYnf8beFwJQ+hiXd2JfVPO2KN65SlvZeTlFKR1rudq6hT+
	sjPJVYrwxJMaFwu6GiqxRKVlNazIpQcL6nvt3EblMb02KbkyVI1w+C7PWFeR7xTmPwkOBcmeP/h
	wW05tfW8bFhlf1o5SlCCi35BABXvhGCnD9SQgXSTBb4nrGTUQ70K4RbbUe6SKrk4baf2njDvqJv
	fbR2DjtuhWP2hNA==
X-Google-Smtp-Source: AGHT+IGkGnHbLIn801xCGU82RWbYfOTtwD3A6j+paaPOoROSvLFCIITJYaZdYOz0jWnjfr9kA2bjBA==
X-Received: by 2002:ac2:5684:0:b0:560:9702:4fe6 with SMTP id 2adb3069b0e04-58cb9f0b790mr4028661e87.24.1759745175951;
        Mon, 06 Oct 2025 03:06:15 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0118d372sm4887469e87.87.2025.10.06.03.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 03:06:15 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 6 Oct 2025 12:06:13 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOOUlW0SbBcPM6Mq@milan>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
 <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
 <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
X-Rspamd-Queue-Id: 3B3AF120002
X-Stat-Signature: 78h3a5gjbwnzu9ixxfcdfwcidiceds8j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759745177-864301
X-HE-Meta: U2FsdGVkX18OnJbhJ590K1s0LLJtHlihV38Bt+ipw3bizif2z/6vuLKMjwavDa2qmQP0wqsjuVUrwIYg17eJo4ilzsj07aPvX3ET7fFw5ar7DkyD+BFCperBzRCAHHGCMvQqDaoN7jG+yDnlRpWQEeLV0bkXbZ8fipB7lJStD75GV3I2BwmeAIgjtttJT9PAfhxSBFyUWPAoaZ1mcmEHbatm6tL55CrENYwuIborg4c1PnGFcu8aeamhT1oVmYS4xp211m2/fUfXNnl8mRIqBAzUXJTitvoLfM+ovRc68Srat+pp405ChHXKiXQJ9cOX3QZ8lzolE/IrHesmxvQ2VprPEn3tGnZcASaxsx4BXwbBn2MNliO5Qid/Xcd7yX5+6bio+rSalKHgYc6Tv7ez4yel5ttYZvwvHYQLjahxJjpTlkI4Rk9tqoug40vdk8jwiFXph+GOM6FEGJ11QlljtAvUyFZORjzhkht2lF+R7f9wM1YouSkS1HQ8jCol2up6BhvA7ESMysdxsSg8hHwY8O+liIu2GJI/NKlwR6IhadfN+rnYM4luXoIs/VvthSZrtYqpi5LtXFFjOwtb0GNBt8zCZyxg7G06ig6JdQBhluTiHTjJlqnzKl7//Nv3UexZhFBHmmtfP03MDQuxPKYrWZXd1vr7m5liLMfZphdeK6TzZKMIXkC20eieDnriFC/yKi488AFYjean2KOEzFRbTec4nhNGX4dyiNlz7zDQgmmvveAL+7dnku1EABspZ7+CpYGcN/gf+iSM7kUOe3msJ60wFwRRxM/zkBgd76SQy7eM+9ARjlEoaVPawl2DHzWuXlnTCmymPl2kXLNYp3aj/df/tLl3caoFrDE89SbAu2zVNHajdIxULYgrFkk3uJI/iFXBWQp3YpVMJDK+SwcF+NkEyR7B/xXgrVikzWvTdhIXyxXhd/HZCSc2URc8Bo0CIYGklY8EsgPxueAvfte
 Da1lOZWU
 0FrFUCfeEKFWvlXeavLhHYsEjYF/fGfnlTXtS1hfAoxiQLXaZgpQm83yQIiSG4rdRrVZtWi2F19N35jOnkE8fOc5GE6gtv5fM/FrcUn4M6BJ1p6KhTxb/7xL09kNVepwYh1XHJiGf0WIvX1dJdSpSBgfmfdN+gpyuXYbozITO5BlHhoo6dw2XdD2UHFlxsvJj7XRC78LPojTZD4w6el3+hTx9+LJaYyOBJidT0ZvS2dOKGLuujafiiA/Efq0dq3J3DAPzE+hmtZR+RTHCNMJOFu/4NXJESEetptUCY0A2r3Zr3mdqlCvqa9/6GvuSRrG2gDcWwkzWav50hs9dHGfa39w1yWPBbjvuSKeiPFqsRmLCBSVMvl4bsbKkO/UDlu43oaRPfRqmgvK5hkngEL8W8GOCWgwCvJ/jaqcuTZE7aO3UscHayLgpXC+vtW8dQY40VgwMSvTu4Q6oOhbb/KRP1SC8p06LPPwOIoZPa7yWXuYQIE8Pou3uB5qHLAKE7RvebEF7XATqZLuEUKT+k9vNUdK5WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 01:02:02PM +0800, Baoquan He wrote:
> On 10/04/25 at 12:11pm, Baoquan He wrote:
> > On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> > > __vmalloc() function now supports non-blocking flags such as
> > > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > > 
> > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > ---
> > >  mm/vmalloc.c | 21 +++++++++++----------
> > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index d7e7049e01f8..2b45cd4ce119 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > >   * @caller:		  caller's return address
> > >   *
> > >   * Allocate enough pages to cover @size from the page level
> > > - * allocator with @gfp_mask flags. Please note that the full set of gfp
> > > - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> > > - * supported.
> > > - * Zone modifiers are not supported. From the reclaim modifiers
> > > - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> > > - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> > > - * __GFP_RETRY_MAYFAIL are not supported).
> > > + * allocator with @gfp_mask flags and map them into contiguous
> > > + * virtual range with protection @prot.
> > >   *
> > > - * __GFP_NOWARN can be used to suppress failures messages.
> > > + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > > + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > > + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> > > + * by __vmalloc().
> > > +
> > > + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > + * and %__GFP_RETRY_MAYFAIL are not supported.
> > 
> > Do we need to update the documentation of __vmalloc_node_noprof()
> > accordingly? I see it has below description about "Retry modifiers"
> > where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
> > but have different description. Not sure if I missed anything.
> > 
> > ===
> >  * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> >  * and %__GFP_RETRY_MAYFAIL are not supported.
> > ===
> 
> Sorry, I copied the wrong sentences. Below is copied from documentation
> of __vmalloc_node_noprof().
> ====
>  * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
>  * and __GFP_NOFAIL are not supported
> ====
> 
> 
> > 
> > >   *
> > > - * Map them into contiguous kernel virtual space, using a pagetable
> > > - * protection of @prot.
> > > + * %__GFP_NOWARN can be used to suppress failure messages.
> > >   *
> > > + * Can not be called from interrupt nor NMI contexts.
> > >   * Return: the address of the area or %NULL on failure
> > >   */
> > >  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > > -- 
> > > 2.47.3
> > > 
> > 
> 
We need. But i am not sure it should be fully copy-pasted from the
__vmalloc_node_range_noprof(). At least __GFP_NOFAIL is supported
and thus stating that it is not - is wrong.

It has to be fixed but not by this series because when __GFP_NOFAIL
support was introduced the doc. should have to be updated accordingly.

--
Uladzislau Rezki

