Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E3AD0E6F8
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C948A6B002A; Tue, 25 Nov 2025 10:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45006B002B; Tue, 25 Nov 2025 10:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CC66B002D; Tue, 25 Nov 2025 10:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 972446B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:19:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 369AB139581
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:19:51 +0000 (UTC)
X-FDA: 84149489382.24.B512D2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id BD788C000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:19:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZF1wZAi;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764083989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJCcCheD2huAJwH505ntOeFs5jdCHpYTsZMmb5cwYfw=;
	b=jrrEdJjSYDge3rZdfIl1buHhLg1YC4NlS8RJupDYvKnlWZxi1etWlrnC6K1ykR175deEZk
	Lmy5l4B/jGWFHYJm/ScmLaMPKJN2BLBODWyYbsH+DsKXS6ygg4Y+ky+RtX+x5gQ1o8Emdy
	O5VsiHwxJsfrOkpcrkCKur00N9ExH/U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZF1wZAi;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764083989; a=rsa-sha256;
	cv=none;
	b=pCmsOSiD2uDSp6Fs/GD4VvEdcZrkRevVH+seHNdkLJA6XVHkKDj2SVrpsJGo0YAaR2atYj
	4XGYaoVekDbgVVEFtQtQsG0RPyaN0c1MmDFUcQWtq9NurUu0h2/vmnCGsw/hOQ3XVmDVkN
	4cGE8pi6cX/3btX0e0UbmMGwt7GqygQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764083988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FJCcCheD2huAJwH505ntOeFs5jdCHpYTsZMmb5cwYfw=;
	b=hZF1wZAi8a9hhe6fu+PXcy4yMf95mdaP1LQKxmnw0RArXT+aCiQTyHF55RupF8OYP1P/Q+
	keFjCkXqnHXsFqTnnw2Rh+1OpUwmMEydKQdV1g/3kvOGTOGNIpuYojsgdUX9mlz0X/5BKo
	5jZAcLGcA42Hdf8MS0J1+iFjlUCHX8M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-l7ikL_lROmy10kAskT9lgQ-1; Tue, 25 Nov 2025 10:19:45 -0500
X-MC-Unique: l7ikL_lROmy10kAskT9lgQ-1
X-Mimecast-MFC-AGG-ID: l7ikL_lROmy10kAskT9lgQ_1764083985
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-880501dcc67so225047146d6.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764083985; x=1764688785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJCcCheD2huAJwH505ntOeFs5jdCHpYTsZMmb5cwYfw=;
        b=Y0QzOeNJOwT7kofFB0sLMzco8aLERWfs+BfRiNPGRg/w0ubVxuuXaUzbOMNwr++ETy
         RicssZV3vv1s52ocsmrpgoyLgqVX38PFjaugIzLiHjQnjEqlToEd92Gngn2pigfKdw5F
         KZ3zXy1djrFTkwnV9HTTblpWB/pDcrz++RvlsVRJ0PQUeg9bLhze9EFs8S0iJ0TJ/QG8
         9aOVb8kww/ku1cwiBmbAHbSfnVztvGft4ux/FIQ7+lsI4yGFcj03msWELIuLkcAjaNAi
         q+T946dKJmy+3acxPGh5LZLQX+4bIX0aln5qCR4eCog10XXMISXpFtulx3lP4BxK/lJ1
         0VOA==
X-Forwarded-Encrypted: i=1; AJvYcCUtUj+G4mLYAjlrsdbji2werj/ZVJxsIJz3jKa4dSkEIy7jdaAr0K6eAl4LrstOfYKXHbYCABBycA==@kvack.org
X-Gm-Message-State: AOJu0Yy4Rn3jdck5XNWgpFWBfK+2tZpzAdsyBrgWYS5GLbjb4E+CV4n5
	j9pz36/wefbNuSAcitYy1V+hU4uVnhfhxqBf3UhfgOu/ug9nwTU4bKnii3CssTkttu51DJhIHcH
	Ac+7c8KI8mkJl+S2jQJq7lyRWjOupbafLDIyW9Qe+JD49SJ9uYj0a
X-Gm-Gg: ASbGncu5qUaQijIXYYnAyrkneFIGFR5h9jSCDKJuW1HHU4B1oyHUtGbJ5GlOJYlnGwc
	ZgA2ftzO7jOJ9wBNUNyIbJXpWz2wKsv8pWTmfXXFzoNvxCnL/mgAoluccZ4W0KzLGT496JH+bRv
	995aa4V5TOYf82NMg0N5dtBsf7oF4xza88iTPRDYkfK9dPBxGRO4X3aAx0PQFqf6gpOysJOnH8I
	yR7LMV2ODZV1KAi0IDf3sxqqH0FlubMfEGvvvNeOXLH5AvZvJ9N/H2Ir2+q6P2YYq3aC4uy7ujk
	BFEHmJYygnVxwHLrXsXBO4cs73dvWQfgZfVergoRdrbFcmVg4SWnJNa5KoZLAtIa
X-Received: by 2002:ac8:7fc6:0:b0:4ed:2164:5018 with SMTP id d75a77b69052e-4ee58b05cb4mr204295181cf.80.1764083984639;
        Tue, 25 Nov 2025 07:19:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFe/SSNC4T50Q/+lEiAKmmcIWfk6X2N8U0/RvmBuwSBcHNPn9T6SfGTxVn45Sgi4+8tvgFTgw==
X-Received: by 2002:ac8:7fc6:0:b0:4ed:2164:5018 with SMTP id d75a77b69052e-4ee58b05cb4mr204294651cf.80.1764083984128;
        Tue, 25 Nov 2025 07:19:44 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e67fa9sm108549131cf.23.2025.11.25.07.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 07:19:43 -0800 (PST)
Date: Tue, 25 Nov 2025 10:19:42 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: add Mike Rapoport as maintainer for
 userfaultfd
Message-ID: <aSXJDtFFN65fcVur@x1.local>
References: <20251125132908.847055-1-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251125132908.847055-1-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8STx3pKPFeWRmRIcRUL7NQ6focc4e8PtGrqOv6Bhuwc_1764083985
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: BD788C000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dhc5p4yukr8zauu5z7mmgqbzcdp1c497
X-HE-Tag: 1764083988-208570
X-HE-Meta: U2FsdGVkX19Lu0+y/S9qwH5xX5kF/DK6J6xXeYoMOO/WYuTE+cVWcGBDeOnIYLLlb1v1CCC8U0lnsa7E9GPOdngD4uiSxA/E50bOKBmnwo40RVEmmIZr3SMF1nr3P6T10eX+p7Ga9QqA8c4GdKPvkVxRhRyT5hkkrzcxh9aiq02CbixUtxY6UGCayuHHsFfMsaygCkPWr+EsgzpAqHWJl89Y1UvC26Ato5O2QfCQEaKBY/KqJ/5e3yOTsEfTfagCf6tQjlWELZEIo78Bp9wjic5xEHCdZljVYpTCp8VPGfhtWCXbVowvKVEjxNBnvVQchVCFeeJm0ikah962ZhcDYR1KIjmbgy2rLh4RcIa+SxZo93QQelY5QbIYKxGKKGY/l1XL5v9w4g0yAt8teBbcC0uXWBbwt0zXMwLvXEArHniqgBo33lmCp0DgDYX99JetY1tTzvGw9m7PPR72iz0t+PwkOYIPW2UXk3hCG31PqeoDvxl4EJtv1dB1BHCdgj7mg3qkqjW/nk+R0/BkUgZJVH7p8PiYAQAzR9Jl2VQn6WcD7soEBtDcD3nszIZ4x5F1++8JD5hR9DRiMj1oIm7YgeeZonNtXXAv3xiXf5VsfzcIiwIAAS14xOjts3tu6Dk/0g+1LhU6yw87pfc+HoXIpJlH5dQiLAsTUHhT/GZx2dscEVlpZ01IMuKDx1gAIhmZmneQ67yVIg+EKMwO6v9y4tU10o5pDsDGHRNJ9ildfk4eQM1C5vQ5xre8Unr4wC0MS803yNMYg5+2OCpry/XheOobUWYvMhOKWoBUSQWCCBO77qcXpvBhX/7ZwQYKgRMnUvMpoojxsSN99lbErr4UogydAV1GyYx1tr2xQnAtAsJspbwy+sZbLZhNy2aCSZxGqdgu1OjctPcHLaI8jJOxb4+oNUI6ZG9uTD/shS4vrf4KML7ZxynYnolnogcGBMeLLmu/j2HWXbbeiwI4uHp
 +/SEEtIX
 fD5Xipc/9MYvAsfdoDqEv71UoA/qw1CXWFBx3k+GaupsGe0RxSrpL+FOv0JRdBG5yBlQZU/mLg9YoeqT4oXNcn4D0u0mCnEjQ3xGvgyzEK51fxHpBtjV9LeBK99T7elAXYgdvIIcIvNpxlepa2Ii0QYYUORHzULKxeh/MN57/m2PztjcXyaX3YT9A4F4HekVM/ZHXQCjyxk7TpHZHKGfxmqHX47ukF8+IWSAQb/qDJh/kfQ9pJQGio3NfJKcJRqfA5SIivGlELXNJnPOffyLGTjKU6OVIqsNUe1uw/6aUdW0lf48TFh0uPIpNn8UrEaykJkN+8FCWGlmqN+7jvlAPavcog79oNwwWtdKiZhci0Xf59yHCl7qLKgYcblv39c5FPTZ3VC5Bw9wSOfObOeMJsvVtKM5VbxPbePxb+aIR34V/b+1P9GKVfdBbCkGrKSdQjo57IXRLuEIzmfLPPexJ/uhNKT1v8i4e0uqK91MXF3oSDK3e5sH19QZZBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 03:29:08PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


