Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342EDCD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0A86B0098; Sun, 17 May 2026 14:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871576B0099; Sun, 17 May 2026 14:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7601F6B009B; Sun, 17 May 2026 14:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6429D6B0098
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:52:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DEFFA06D4
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:52:08 +0000 (UTC)
X-FDA: 84777806736.29.FBE5A15
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03B21100009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:52:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CrPm4QeA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMikKmjIRuhmCNsf7ga38/uSHQiRF0nG0AquMF025/Q=;
	b=28DFsNIAs3oF+/41ruOklFXnXExwg55yDxaiQALSJGvefInd4oRZVm7XoeGjw1gAXg1Rjc
	Qj+r6xHS4qq1YTNg7gd/oYto1hBZJ2wLSnabeFbIQ+LT/Z+DvnxsofEDwBeRM1qKZ2eL1Z
	7ZWtQe31jy6cd5kDS4lgP9kXh7Vc7Xo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043926; a=rsa-sha256;
	cv=none;
	b=qo7akbLAu5iKtZo9S+HDv6A+DcAuZ7KWtyJ5xffzw3FFt/h8jlgzOW1xw+lWox1VbLSYF0
	Ybv0IrgyJmwpwssGorRNu6Cf1GAzSk9DDBeJq9PEjuwRSNSU/ClZI08y913zZ/1BX98jHD
	oyvBZuJ5bbUm7SZReJ46i0J+/QnOqQA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CrPm4QeA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50faeb8317bso17265821cf.2
        for <linux-mm@kvack.org>; Sun, 17 May 2026 11:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779043925; x=1779648725; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMikKmjIRuhmCNsf7ga38/uSHQiRF0nG0AquMF025/Q=;
        b=CrPm4QeAGuxXI6bhyAKRm/yEhBL4w7VQWCrgIwZk2oqhCC9MTyB+iQzNC7EuEweQfl
         zL+SppTIA28tGebAmk+gybdihvuDZekNPrergP0tBQw9wGuaTyOX/E8/9L2f6pm+6fqI
         +96y6Zoe6vvnd0Kgrd21pIfi3yVaWGyP2CsB22/iJ7QNg/bYEv0DECUNF42T5A2h8CL6
         cGPCDP5V9nVugZtdO3giOtqvFvY1aRo6slO5OpftPA/o46eP9XT1Waaf+26SUvO0q5wf
         nbAaz52/4NdQjQPBTZ3hztqI2ajf2EhYeMaoOc33uxsfQSKBZ0W4SaexGYMlmblfB7oy
         Xz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779043925; x=1779648725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rMikKmjIRuhmCNsf7ga38/uSHQiRF0nG0AquMF025/Q=;
        b=CeJzq+sOENg7AM0Bk3mDcwR5AEAJtX34QEQjWda/km6SVuXn/4HK70xGUmiSphZ27b
         cinlN5T7ENsue3a9bUJha2ZC+dKDx23rbEgtCMDveSo57AxJqgbQE0M1xy2/qlnkAbp4
         bIrmT+Nvff2o4MeRGETmx0FHISgjrqt8ddUzDnG0WY8BVKQ/aWo2z5CS9xQ8vBZ0HXhN
         45HLTH9hA0328ErfnbG1rXA+wGcatDea/W+LA3I90A68JmdtFMW0AZmkpoO/ClmaZPQI
         pjQ2kJlidaKZHudxorRSBN5HLJmQtubRgXUmTJAuuxaeoVSoXrkicgR9iwQj5gMUuBcs
         5Hdw==
X-Forwarded-Encrypted: i=1; AFNElJ8y2QZMl2Ad4hA+dwGOsTRsuezGYqbmJ2fKmvPdEz4jRQehBxRXklUYMRduwo+G1Wp3YCA29+lK3A==@kvack.org
X-Gm-Message-State: AOJu0Yyie98lQSJlCCyGNWYY+a7LljtMUDwkYOj7VcNFE6Mv5IkkzFJ6
	DQdtX5wFZ0e5phgS6GjAJEnBMf8Hg1BMRW492ahtOED3NhR24VTv9rgKiRlJ4dETMQU=
X-Gm-Gg: Acq92OGPnLNwgf9m9CoBV5unaKCnoLxTA6JR5k05KNPgAVVpVPLHAg15eLe40Gwr9Xv
	DwXfRdMeOmz5lBBQ0jh2sI4bFMtnM+Mtr6MTZuc/hqAEnNjX/KqJDmE7Fatb+1y03Rkv5dkKpJO
	wTKhAvipgxpZt0ROCga22hyq7HkS8Cmfaffav0cLFScpQAspJ6tkFj6FQxcSCuLNLDnMhlhtG9u
	U+spOI3VrEUv27H8bDO9YMcMbcbmE0oTMiAgjksLoKM8JnEbbCSIPstBeANzvzNcCAq9a0Dbq91
	bI99s74Cyj5qWLXhF3Zid5R9LtaG9hZ06cJ1SPdrXKX8hQykPrgatlhy9WkShbgVyERMFscu9dd
	D21w6D5oL/aRSeHOPYCaVGEJpn80jjHdSpcZ5cEeLkaxyeg36qgEpAWyy4BreJ0+DejpAkJKRtc
	M5a7gsdiTBUzkfPhnuoOBh7S2lNHFJbY2yU7d4S9auph/IfWV7/bw=
X-Received: by 2002:a05:622a:6201:b0:50e:5819:d7e7 with SMTP id d75a77b69052e-51659ff8947mr173729421cf.3.1779043925075;
        Sun, 17 May 2026 11:52:05 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456888f6sm114656631cf.3.2026.05.17.11.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:52:03 -0700 (PDT)
Date: Sun, 17 May 2026 18:52:02 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v2 05/10] liveupdate: defer session block allocation and
 PA setting
Message-ID: <agoL1Afx2cHUNmE9@plex>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-6-pasha.tatashin@soleen.com>
 <agn7XnuO7VU4eK52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agn7XnuO7VU4eK52@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 03B21100009
X-Rspamd-Server: rspam04
X-Stat-Signature: btefat6h58zjdw6g9o76kwhirw3h86kp
X-HE-Tag: 1779043925-820029
X-HE-Meta: U2FsdGVkX18cD0tPBEx2y6rMJvlEe3qok/moEt6LRIhi44qkAO+ZlLzEFKCJyqh1aYoZIt0SDp0VPNRUpglkDvd20IsSUi1WdouNNXPOhpAK1VsSO7onrwtr3OwM9shDtzGTNVCa//Og+/0Z4x0/j7Ogfj6wdhMuHho0hbRYBjlfM6GV1hOqrbh+DhrJPU4cGYcKObeNfAZynXn5q+q6Tvh0rHHNBxL/9ROAFz2HL1LdA1OcAuqw21y9bJNvWLLg8NYrz0P7ayiHlHE8yQ93hqVTOT7A87YP6Bv8NUvH7Cp/8mukmRaKA6HxhJV21wPWZFILSHjmaNA1TKsH+37MXuiChLKDXp7tpJV72vFJJdQBF6u/6b3binX4DSvFmFiLavSBp3cIQwB9OuQpsNNGKqQBznJzQ09smxOfJ/iOk4vUjAokwpdiUEbqaA/6J3UiTSmJ3bSjqFk5LskfBIAO0PzheB5gHldb5A4E1kXAqjMhNg3JxpL3rCfDqVsWpxDBNfzu4TV7KB7Q/Lw5BUG16ZtPYVipKLUbZvNLGB4BokWEMipU61wKcpYDpGoaqSVJiH64wbxQra0UVgwJ8ghr/JzFO+Mxu7P6b+RuJ1SSr22btjSyQw5MMvGl+zz8NupaYyVAjTmy0cyaGs6+JUe8RhaCkQkRgYHRPgQ4zAntf13IxEOGjHcWm9wKzYISvIXW9fBsxkg6N0ULJCzLLmVWa5pgG9WQcggPlaBsQOzuq7YzDGpi/eCt/Z6GNM159VisIJS43OFPy0Klrogpne2cHlYyioqFHxB7WmjTwAtAzpDYxKGL0YwmzUwMHf0vEFmC3pLjMHJIjGNGhnYlgGU/xoo4c6FV3/NJg1VS1zqEZ6j8JdyCilA+KywP1WlsfoPrJAdvfBKtbIJHas2eY4v4EYV/AmohXs3K0OWaitUuXOGy8QWCWME1QOELW0bv3aDxoLHl2TXkzQuq2TmdEfU
 LaDOoLKT
 yyu/Jebi4FukdWZIn9ukDBy9YtLXUGNTOQNwKcEcbaIXhHOpqQe2GgVBlSd9FOJiloPK3NfmkSGYp2BuOuwBBApFd/lR5mq0gPLh+HxOFGXOzdbEWFv/ZUquYznuDFoDaV3acT/NNvxOLSeh1BmtRu9k/naQ0HbGKyKNz7If/IgDvj1tZfmlU45ZM/TgjNcRWqmsLWzE4nRxtL9ZHKiugkLF0BKTUmKZOsPBIkU2cbuunXbpPXHWrExDnj9ED6BJwM6gCIvgzwWTLmKyYO1K45SM+qR4Wifn0CGAVI6hNLXfl1tDhvxw2url75FvVDxdy+eP5Tf1KDy+5imVY+Z8vCOULnRyceA0pKHKBZxHljS9pT+m5mluFKJzG9gOQrd/lBOsUeNWClRmC3JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-17 20:31, Mike Rapoport wrote:
> On Thu, May 14, 2026 at 10:26:23PM +0000, Pasha Tatashin wrote:
> > Currently, luo_session_setup_outgoing() allocates the session block and
> > sets its physical address in the header immediately. With upcoming
> > dynamic block-based session management, this makes the first block
> > different from the rest. Move the allocation to where it is first needed.
> > 
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> > ---
> > @@ -77,15 +77,16 @@
> >  
> >  /**
> >   * struct luo_session_header - Header struct for managing LUO sessions.
> > - * @count:      The number of sessions currently tracked in the @list.
> > - * @list:       The head of the linked list of `struct luo_session` instances.
> > - * @rwsem:      A read-write semaphore providing synchronized access to the
> > - *              session list and other fields in this structure.
> > - * @header_ser: The header data of serialization array.
> > - * @ser:        The serialized session data (an array of
> > - *              `struct luo_session_ser`).
> > - * @active:     Set to true when first initialized. If previous kernel did not
> > - *              send session data, active stays false for incoming.
> > + * @count:       The number of sessions currently tracked in the @list.
> > + * @list:        The head of the linked list of `struct luo_session` instances.
> > + * @rwsem:       A read-write semaphore providing synchronized access to the
> > + *               session list and other fields in this structure.
> > + * @header_ser:  The header data of serialization array.
> > + * @ser:         The serialized session data (an array of
> > + *               `struct luo_session_ser`).
> > + * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
> > + * @active:      Set to true when first initialized. If previous kernel did not
> > + *               send session data, active stays false for incoming.
> 
> Hmm, why addition of a single field changed the entire block? :/

Yes, I had to decide whether to shorten the field name or change the 
entire block. I opted for the latter. :-)

> 
> >   */
> >  struct luo_session_header {
> >  	long count;
> 
> -- 
> Sincerely yours,
> Mike.

