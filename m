Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F075CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 00:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB74F8E0003; Tue,  9 Sep 2025 20:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F288E0001; Tue,  9 Sep 2025 20:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBEE8E0003; Tue,  9 Sep 2025 20:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9CF38E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:01:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F4C811A5D1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:01:47 +0000 (UTC)
X-FDA: 83871387054.26.71B1379
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6CECD12000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:01:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gf4xuWLr;
	spf=pass (imf29.hostedemail.com: domain of briannorris@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=briannorris@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757462505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqcDWqfJLwLOyJ5y56FcG8QSqOyBU74DK/OOgsSQXCI=;
	b=in/IRKCunJEUUuNrG/7vlJHVa11OGURcqp5a1nLtq8KRAEIjoArEcSJ4smvfLbZUPwjzJH
	lRLp82dydUNP0V+JhPz8+kwsdv7G4HdRJ8igs04vTVpARyKFfKqWXMa6WCogwX0eypvTqp
	mZ3Hyxfz331i0hDm0cCMEr9K9aJx0io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757462505; a=rsa-sha256;
	cv=none;
	b=7S96GYPv+OBBpaYLMUvQnz+mrfCjJ/gSuFpDavLrcXu26Au9kBHXW+YiZ03xYkNbyk2BVp
	A9Ql3hkjti+UgYiqbFUfh+RESnrRZddxdMxWZ14Mcn+dQ2tflIYyrNEu3kUULurih5nCeP
	hsSmDg+URdJuOvS7YKSq7nuIBVREEd0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gf4xuWLr;
	spf=pass (imf29.hostedemail.com: domain of briannorris@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=briannorris@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-25221fa3c9bso990645ad.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 17:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757462504; x=1758067304; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqcDWqfJLwLOyJ5y56FcG8QSqOyBU74DK/OOgsSQXCI=;
        b=gf4xuWLrG3aOFmyESAvq6v1nekrh7QmD/AGi8wbvlfbONXR0Hl8lUhZswxVvHhByDJ
         Uy2PYewKfPeLmykgmVQiYTSwJ/3ewzGEeP0v1UvkHdrEZqMgLfw8W7aK7vEtcxLo4Bqs
         0WykrpKCMM8woX941Bf+/iQ0YX65/dTIY2IR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757462504; x=1758067304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqcDWqfJLwLOyJ5y56FcG8QSqOyBU74DK/OOgsSQXCI=;
        b=e00esfURZ2a/WuORwlswnQISflVPWVvVLvCUz1eVP++UNy51JDBAwmH1wnO34X1q3D
         e3Ql8u8tzU3nInE2Nxlazp56YczCn2nIl6qBcl8ami2rFrdY16jl21NBkkN4TKDjUyoF
         YLtFCwJo7qryGcEllDT9ZxJ03SzSPPiC7WQHIEsSdPsVDpUrrseLZy+hSzPGQqxzK+UB
         07kRgCUybGdRN7c89F1ExKqEUfPbU9hhK036Q55kYcGi18V6zoSfcKCz5hfqspSsDDot
         k8yN7SBIUtmqP5LB6SDIGz8eAL9jZ0bJ5XsJer6rVFGcqq8H2sz7BFmIq+7CaHuo3eyN
         oFMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwUSzHftfOKr7mqSm92/n2ulPfFPFsXKwyOYS4KfJRavUVlrSxoxHZIN+IDYs1qFO5UfKYUYA3XA==@kvack.org
X-Gm-Message-State: AOJu0YwA/1c7bzp5Mz9mIjBERFa6JyScLLdhIDKzi10vj7Y5zmKf4ahU
	G1OTpFB2WoKd5tkLL3p/35E9hM7H0J2sc8G5hnyxLtUb0YM+6zHQP8s1HklYqSOxaQ==
X-Gm-Gg: ASbGncuzofReeE7XNm7g6xEKs8pb5da89Ki+0iGUogQBnEJHfO+UM1D+LIQxMrJg/GW
	phe9CDS4Feo2bqhzJKT4cAah4I1nFvuMVJggGVNP0aENLUXbAx58wll3eMUV0M7sWSRY4UIC8Tm
	FDP0ZA8lEUJqApGJqLrbZ0jRDW/uOAzvvqycpK0AzJNRPP8wTUEU3fJ5MLdT1KU1c+UeKWtdjVJ
	ROqVzctbraODGSkroefWwyNe2le2boe5v6NDOt5tUAajPvyTZahew7iynp/YZ0mXhCfZ5bvVfBz
	+NEsMYP33kZYchnJqolmTsguDJ8ed74A185PSM/20ppgyv9tflvuBg+4h0Pcn12N/C6qDuI9ib9
	bsIPZsUjjHGJ/1uqpmkE1mgogTCe1M3ZS9gojyQP5B5JJiOMuTCr0NUFSjr+uh6r3AbegA+Q=
X-Google-Smtp-Source: AGHT+IEWQd9UQ3bAAMXqR5jg79X2RViVbY9wPPCVw9/Jc8wLdWf1qklDEFie7CGAphB6W0gOvDthEw==
X-Received: by 2002:a17:902:e551:b0:24c:7bf0:6e68 with SMTP id d9443c01a7336-24cedc7aa79mr255602615ad.7.1757462504013;
        Tue, 09 Sep 2025 17:01:44 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e14:7:e1f7:9c44:893a:3857])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-25a27422d29sm9186895ad.27.2025.09.09.17.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 17:01:43 -0700 (PDT)
Date: Tue, 9 Sep 2025 17:01:41 -0700
From: Brian Norris <briannorris@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: vm_event_item: Explicit #include for THREAD_SIZE
Message-ID: <aMC_5baavoll9pBM@google.com>
References: <20250909201419.827638-1-briannorris@chromium.org>
 <20250909165336.c9505e477461fd5e41e6cfe4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909165336.c9505e477461fd5e41e6cfe4@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CECD12000A
X-Stat-Signature: jrciisemiqq4rd9x4xaekyzw9qidi39q
X-Rspam-User: 
X-HE-Tag: 1757462505-546666
X-HE-Meta: U2FsdGVkX192jF1G9h3uTQlNlnv3D1KYSpZher6WfccU4GlBZh4gTUe/WERkpUEp44bZSc8YewworN22O6RNz5XzP2H5RFmMBx4qM6ksdi6Uy0rG4qQpfnigSv6CoL01IgcznMCbj63AWu+SzUceBnN0gZ+1DKvzTKsLCcwtBNdRkHnhi0ipV5qNmU7Xkayqp/S5crTADix65AiJ+Nzv5CSY/5H9GYet9Jg0JbU2IFDsS32H8AmdzhoxFi8/wks1bZ1Fz1F0cQ728raSmW3vNWZuN4osxpoUkdII8A7QpnQ1Im0CJ7LXwT/echHiUwDq+MrymN9L00l21xVnoWo9TqCSLusij4Q0i7qe+OoxT35z0tzSKTFdTnc9VBqHysoIgI1YiGtWfCDGH8p+wsa1CmpF1lSiclnpf3OZ+xS0sfx4XTPgHRZD7fSHr23YudKvASLoY6S0nTLF4UJszgXw5pPMUv/vAnXTOsiQ2kji/9qPtBX/2oa9vP5GoDXAeTzy0W+QmkyDD/pl765pwFjh7qanDhLMU6tH7gtXHpXrPoZuvBoVKofYR+6WkYfFdXNDRqZkETy1bBfsJPjwNnmHsVgwSniOahDzYKAtGTMs3wZC7KJl6StA8Wl2S8r3j0ocAVN+SXXh2NEKGEmdfgwxlWOe9L3O5wqx9w2PYsbyuzlrSDxBKBFJC2e+lZq8wPubm7isctFXe1KiJceltCZRxe8n05FhETLyn/JuBLsUKsxK3Ufpme7RexUJotzBRmXIHvsFgjB/pM8JEwT4ySJvIzZjUFUCARH8z9NnnIhAkvep9oPwuxS8SPmZY2xdJlhTJoHO4mmPiLJK8nCg14ny1k4XAOZ3vJnK2csOg4u1S5sLq3rShUK7n/nGAKNRamFFkzOyGXYVPYpc4qUiP7WwQ8+duHrdftch0iEYLVcNzmNREs41SpG6cRLfVNhXFQf+EQmQm8CaNukJnQTIJAQ
 51OmnLra
 zehlaVi1gdIHApS57oPIY7+mgiMZd1qP7PddswKqkF0JU3woeH5gQFdpD5DIDbbJmHfUR2lcH751A3PIntIw3bdI9Bq+WAa1xiJ15U1ynLLcCY9qlY1lsadyU+IG8yyfks6oHbNDM5YBt2M48juIM0Z69plEYAg1mwnjyh3NaQSs52EM8/RcR/QTbY3SCGjUpyybIqklkHW18122qzA9jr0st9Bfa3K2LX3+S2OeWn5CVLun6FapPu+XnRV92fHyRzPkoqMxvpoYNmf0Xrj0GQ5qp7aL2cfOC19HGQT2jmP3ZkwQeGbtwtlslulIfO0IT6FYD+TE1M6Gd8LW9MK4yNkuDYwe0Kjzx3xdKezJVsgjf6sOXpb/HlkyPGAnoD2BZ/8LYJDTtixC0WS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:53:36PM -0700, Andrew Morton wrote:
> On Tue,  9 Sep 2025 13:13:57 -0700 Brian Norris <briannorris@chromium.org> wrote:
> 
> > This header uses THREAD_SIZE, which is provided by the thread_info.h
> > header but is not included in this header. Depending on the #include
> > ordering in other files, this can produce preprocessor errors.
> > 
> > ...
> >
> > --- a/include/linux/vm_event_item.h
> > +++ b/include/linux/vm_event_item.h
> > @@ -2,6 +2,8 @@
> >  #ifndef VM_EVENT_ITEM_H_INCLUDED
> >  #define VM_EVENT_ITEM_H_INCLUDED
> >  
> > +#include <linux/thread_info.h>
> > +
> >  #ifdef CONFIG_ZONE_DMA
> >  #define DMA_ZONE(xx) xx##_DMA,
> >  #else
> 
> Is there a known configuraion which triggers this, or was this from
> inspection?

The original trigger was a non-upstream driver that includes this
header. Since the root cause lay here, I figured I might as well patch
it at the origin.

Brian

