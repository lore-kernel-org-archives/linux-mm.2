Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B6D1CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF378E001B; Wed,  8 Oct 2025 08:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E2F8E0002; Wed,  8 Oct 2025 08:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493E88E001B; Wed,  8 Oct 2025 08:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 339D18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:10:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7ADE59410
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:10:42 +0000 (UTC)
X-FDA: 83974830324.30.17C2515
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id D02E216000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:10:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ap/WRzjp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759925440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLqC1bH/0EiKXqmcXDwHomuoVPXgIMZQ6QzLjCzbq4E=;
	b=dTxEHZYN8nkRgWsfDu9xom2muN2PRYzP2NdpIZgvh45TNIHhCaA3H6oYgAKR6tm7fLFjPx
	8W7/THoy6pVENLT4DgPWw9E1JdKO461eG2tFm84oZHgbrKp2GJuZl4e6ObSjAZfDzgXYwA
	Je1nymKWs8fHcv9xNoDW8xMwqK4/rTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759925440; a=rsa-sha256;
	cv=none;
	b=4rJmkm1AzcuEAOVEpBmYEU7EtkRCxIhfERa0nWE2wI5XF+dnS28SLlvkW4Jwirtup9VgQA
	K1rUI/YliwcPCkQ/gwAjBwnMA17Y+FofIQK0hAooCuEaVUvkY9eKPmYUSE3ZvxqOhQ+iIB
	LJwiVpHywDp9Xhg8p8ACvwWFNCH4G70=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ap/WRzjp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59052926cf9so3419439e87.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759925439; x=1760530239; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VLqC1bH/0EiKXqmcXDwHomuoVPXgIMZQ6QzLjCzbq4E=;
        b=Ap/WRzjp1FZiePBAOSHAxhwQpP1FsWf/DLS9CrzTvDbPoVyzX7/mA46F29ETxECPAp
         Hi8ZRDNdMeNYiK/S/jgADZ5/CqSSWdUUAK7ROtGZfsysL9a0Ly0RlHO7uZMEl3goJcGQ
         QMgd6o7jb0I1YGA0RVt83jAwX6l2WCC+oijxEpIjkBoYtpEIqxGZlbIVxAF+q4lBQNxl
         mQ2HpIPB9kLuGxBKyBk1v9O2tNKRq8kQLacbf+8N1ebnOXpmdKkn3J+ZjXhWFfXNo17D
         vFjfrIXweY+xzSjGAS/JiW5qo/VSQensaLQiEYlMXR2i0gg3qXZAgxkRjfC5AeyvMbbC
         Adlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759925439; x=1760530239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLqC1bH/0EiKXqmcXDwHomuoVPXgIMZQ6QzLjCzbq4E=;
        b=n0fko8rsKgrZHFpXGdyFTO37bC18N1D+xUHim+em2AhIOCusKxDOA0/KK41yJ4TkHM
         H3I6FJw0yyS8Dt5wOw+vGDekU07gsdo439DuuMNq5GtXgC8p9Y/8tKXnxQHYL7lOSy+M
         UCvDuF5UaER8PP8ch6McfbQCwhWgVFm9CjLxGVtZkIyotvygpaWHgO4Z032oePaFsNMe
         gTlVgIhpebEhTI5/M/0X2yuwGYhC/9R9Onc8yOlrwH37ENypqnHO30oBlAlowyim3GMH
         Kx+Qf20JgMd/D+pflZt6xY5QTeWPvK19IaWyX2n28p3RzCcE4i3OOI0WBErXuctGBvx+
         rfaA==
X-Forwarded-Encrypted: i=1; AJvYcCWfaAyvK59JyC+lEJF4tXcLSbpa53xDRX1ymvvRTHaNUPw+68rGos9435oovb2kAknOY7roBQTaCQ==@kvack.org
X-Gm-Message-State: AOJu0Yxef8nYCVGEVjpzMhxH333Pa78xpuunjHeLvOKGsWVTOb09cIda
	JZ7f1UFj25SNk+a7IvsC6XtwiF+rNbbyuZ1ZzKnVA0E8lPLW566iEvff
X-Gm-Gg: ASbGncsO7gme8ourfiKg4aJffI1EZwsT51j/00pGgG98JB19BRrDxGch9yPCw2w/HMN
	x6imt6fdEJv+tQE2iH+EXxeVq4q2WlEd88qO2aGqMkQ5SiCqV068eJ9Dy97mSNDtiKxBx3UEHrn
	l50EGAmYiSjfWA7Zlil9UQ7iUzd77h5wj0v/HLmQCGyZiLfC5RG9Il4StOCjKLkq2Ajc3KbXkQD
	gUp45OiNnj3DXNEzayy/riq35Kj4J/VCEV6H3Uv8ul/pKG7FmasKE81X6HJn59orSDy/8U1YNWI
	2jHbre9JW6IIhzmQ/Ng8YXSxL4PUHaLSyeT1qQT7o08CJ/qwJwil0MYEzlKSavA+eOQXIzcwKjM
	RP5w5aeNG6HTwFzpWLtGcjpXZ
X-Google-Smtp-Source: AGHT+IHnyil3xOIk69WD0FQndQ4jJPTW24dHVnbTdsvNDUjPd/vaXJ7RrAz1O6UkOunwyqcfMbvcoQ==
X-Received: by 2002:a05:6512:3c9c:b0:58a:9251:4013 with SMTP id 2adb3069b0e04-5906de8ff00mr1126261e87.51.1759925438712;
        Wed, 08 Oct 2025 05:10:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59067823d9esm1386992e87.69.2025.10.08.05.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:10:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 8 Oct 2025 14:10:36 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] __vmalloc()/kvmalloc() and no-block support(v4)
Message-ID: <aOZUvDxuTqCYlLx2@milan>
References: <20251007122035.56347-1-urezki@gmail.com>
 <20251007143126.451f73cae2d3d7f5a36e4229@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007143126.451f73cae2d3d7f5a36e4229@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D02E216000C
X-Rspamd-Server: rspam02
X-Stat-Signature: pwit1czz3oqgnu5ghmrbm835gidser1b
X-HE-Tag: 1759925440-595218
X-HE-Meta: U2FsdGVkX1+nbd4I4PFjV11K3dBTCIccmGsU16ge+L3rNOngR2Qn67RLmUMqsoMvXwhuS4xJhiKvH1iWvI8c6zhK0ouZ0gp6BhHrc/b5U2I61T5zGzlEuLa/KEXSoGX+Y2D4p/lDLl+Vrb9lUemYrzG/AWFihqq0xDbKo+a6jpZUM+ChTCxlPr6UKopysvgF2bT2Leoc0tL8JLW6zSDX7A/5v91I8nJiaeWWSuI3fFRNURWltm4jXU+2125BP0HBqR9fNWmR/4WS6hIp4i9fa8NPsDlf3sSB+YzGDYr7okEyAtjef3V42oor7x58Xf7rokfSyPz9RfYU757ZzHF++W5AjI0xAirCkmAviTS+1QSAgIrli15KHuDAfxEUxoxfmDed03fXUWJNdXfHorMhMM9nIgIcdHxhM/W31gWJDShf1lrrUSXTOGHI6ztsCcQ8KlWNzbqDsTZXEBFzj1v0M4HA4wDnefUQQNNPtvpMc4TFVrXkM2rBbs+vBWk9O0xaEIXXu/iruAdgGXOGghmP3bdUCQsoN+RcgapkePAe4zoaU55o3tAZcJ5wfBBD611oDjUcmVrP3Jc3TOLakwl1UWre9WdedOrdSdcBY+J4BBumk0GPMNER9VbeAksMxPv7kjjfix3JPj8G3evUPb+fde9OXT3BjcBU/jNSoew1Fm8NGb4eKL5BcKsOIrXiDNXBwxHi2tbXY2dsXI9o46y39maL+Mwz+Bt3zprGIe1oGwv8nAYQDzKsVAnsajYpn5PCasTN/xP1ffYcnNun6ZqiZBnu1cH4LJpD+4Whw1rSwm9OJLb/JmJVGrrMwIyW26pOUlJ09ITNEEsqb2wf0kAzzM2TA8iCy0mgCiGyaBSNAZFoXsI8O24T6pVDadQQbCI31ps+ohrYnKlQ1aR4baKCRpMBx87fwywB/akcJyAmdVtv4QAGgh3qfUdE0KxkcafB15Y9OY2w6wt1cnrRx59
 bmAWwqaL
 WDojKXil5Ht+8RQRc4kQ9RivmxP0svd8bZ5daUrj0qqpAsmQ0Ja9PiQJNGVq7nso4/sJwQFPncUduVlZSD28uPPCTD1dwx8yb84XoRUtBA2a2xizWEVdXbv3ymj3qj28bwNkN008Q6varr6d1n64wUcOmjpwOzmJSEjsUCjkuP+qUpQNnDKzjZrM/b4g9z6eJxJbXSu/D/jNPJV4P/e/3J8YmH++EIBF3sii71Ds+TVBj8yeuszs5aKDN9+zcj4iV+Qb+86tdohzNyfYY5ag/m2h0rYnNpPpmJWz08pZWP+lVNH2b4H3xojPvutXjZ0csiQSEjXUEBSVnmRsu+MjLQQvXZQqQkn2fxdQ8pOb5JI2VfIHCag0uhpXridjOZ0+L/nA0X0fz6ZxXO4rrT/1q4JIY6vsaY5fwc8SN9min4/MSZIkPyF2C7FqZZAe6BPEnbmvnNa7rNjOzQuScJdTOrJsVo21PL2Ghqi43M4fEEeMJZw+y17uTkdU+txw9Eu47YPHzpnBfKoZ6odYk2Nf4L20dqIlbCxuGyKSCw1aZtVjpK7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 02:31:26PM -0700, Andrew Morton wrote:
> On Tue,  7 Oct 2025 14:20:25 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > This is v4. It is based on the next-20250929 branch. I am pretty done
> > with it, if no objections, appreciate if it is taken.
> > 
> > https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
> > https://lkml.org/lkml/2025/8/7/332
> > https://lore.kernel.org/all/20251001192647.195204-1-urezki@gmail.com/
> 
> It would be nice (and conventional) to have a [0/N]
> introduction/overview, please.  I went back through the previous
> iterations and could have kind of used
> https://lkml.org/lkml/2025/8/7/332, but that doesn't look very
> applicable.
> 
OK, next time i will numerate links so it is easier to keep track of it.

Thank you!

--
Uladzislau Rezki

