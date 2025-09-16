Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177BDCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519698E0006; Tue, 16 Sep 2025 12:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9A88E0001; Tue, 16 Sep 2025 12:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391678E0006; Tue, 16 Sep 2025 12:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23F7A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:13:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF4AA160240
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:13:36 +0000 (UTC)
X-FDA: 83895608832.12.9495F07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7ECE214000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:13:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iMK9WVX1;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758039214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65azH1jsUTpw3Ik/CUwx5rbudKsZMBfFw4WUd87cGcY=;
	b=3iJpnOK5hWBoRH7NJltCLGXK3Q6a9wdIdRQ3qeKXwhVgRd1nhXSTegHn5d6yjL0x750VWu
	M+1rCI/mzjLiemQzCRJgyOA2IwKyRyIhO0UPfd2k05RPmtuT8x6au1SSLNpJsaQEGX2pck
	VYmbOw1ZVWxKTHEvOxSTdkBWSsWIRzA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iMK9WVX1;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758039214; a=rsa-sha256;
	cv=none;
	b=qSP4LBgw92I2QLhGcK26nNOswR5xXQSdRjznk91B8ZlusKW90KFCT+by+exY9R/sF9FAkI
	dKaLebN/pqWeDtYa55XsSTR/6/sRHWJplLRPG1wrIzNa/83XPpsNS61TXfXXe4mLgVKyGj
	QoANiscuzHGE4pNpdI0wZHyYuX3nPPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758039213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=65azH1jsUTpw3Ik/CUwx5rbudKsZMBfFw4WUd87cGcY=;
	b=iMK9WVX1zGlUwYUa1fXl00vDJmLQmmOTqZQbEaBJfGwwd13TR2GGU7Erwzb1G6tbmvNQwc
	yCFdOL61vRfohw5+oawgfRJFF+0CLRLWg8hutgoDU843f1vGFK/rsq+DSLcBVO5k/qDsUB
	1G8Ozn6Bn/fMSVJq0rjcOwI9Znzlh/g=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-qpngEzB7ONiIvxK7ZY9LDg-1; Tue, 16 Sep 2025 12:13:31 -0400
X-MC-Unique: qpngEzB7ONiIvxK7ZY9LDg-1
X-Mimecast-MFC-AGG-ID: qpngEzB7ONiIvxK7ZY9LDg_1758039210
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-72390769037so51102917b3.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758039210; x=1758644010;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65azH1jsUTpw3Ik/CUwx5rbudKsZMBfFw4WUd87cGcY=;
        b=oZsmXOSr9/ybl1XyX0O9JOUSAtTUKaWi/cRHX17qFP2g1/vYvLmtzqDds6SG6XnWvO
         nlkLLZWN8jbJ+onjmtQ13KTOEJiekialFWtEr/X29d1K4MsvLOLUX4PxMVcSPCPH3wNh
         gQI9wmL3pisYj4vq/Gx+2EV8AUI/+0pfcVl+1311IlIIj2lH2AgYJ/u+vcYE0ScVn8ss
         OvSnRfo79aon8JCpYNKBYLYJVYq1rG+wwEnV5vD9Bu00iiEzkhnVDHlGbprPujsLfnkX
         3ZrU/vtJ7BJS1P+G+ZAP5wUJFrIgNMladVna8dyl5374acpkA3FL9Gd13bou3Zw8vwYB
         n45Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtyZshiXgN9HVS6YAg9wLNXM8toWWxFlePYF++0sOduy2OQ0tpcs0MGKd/pddnvfCKYNJrK0Wa2A==@kvack.org
X-Gm-Message-State: AOJu0YxjF5ZWh6aGLLAjiEzWplzF30DtriBCwEW8DZCrKw8TAPb9KVOQ
	vdWfepETWAiKxNlKWUci6mMEtiw2A3ZDSxdehfLwKs2Mjygp/ZAz3OwRtBvlHKJyLwPrVgal1Ts
	vedr/aPbdtEI5bgu9yjpOxG8p3xJJY2rF6/PL43FVvRypWVvm5FUUwjeh79lP
X-Gm-Gg: ASbGncv6BY6P1hvU94q3BIaP7MWdaPnELsSFOEu7WwVeqg7acHM57jlEj1rfYVPUDog
	zAe4YlwDi+CM2DD/tzQOjYLhcJCTuSiHPqMZSP8Iue6nY7i0tMZkkvEz/s75p8hFlyjlaUDXBRp
	tuPNbjLNlzNsF+/AlaFl3kdpyz3MApKm36HKjHjVsyop1F3dYoCZSrzRAcMKQuoLmjURscDHOfX
	h0Uu5ddCJnOXsbH5OsvBQYyOwui/gyKCbybTnh0AiUZmTo8qv/BHM6gKi52tVrCtylTpRiTSJvJ
	zQOPXpJBbo80vXPy/eZK3U1D0T2/7jmp
X-Received: by 2002:a05:690c:4445:b0:720:4ec:3f89 with SMTP id 00721157ae682-73065daa77fmr137618937b3.46.1758039210133;
        Tue, 16 Sep 2025 09:13:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBKT9yDghfWM4YcJYUY15kqJqM1RYx/H1v0Nd8+r3jcFNHyRcxeYZultKitgFOwosyhTx0OQ==
X-Received: by 2002:a05:690c:4445:b0:720:4ec:3f89 with SMTP id 00721157ae682-73065daa77fmr137618607b3.46.1758039209550;
        Tue, 16 Sep 2025 09:13:29 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f796974f9sm40700407b3.53.2025.09.16.09.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 09:13:29 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:13:17 -0400
From: Peter Xu <peterx@redhat.com>
To: "David P. Reed" <dpreed@deepplum.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range
 fails
Message-ID: <aMmMnfU-Koopc9mL@x1.local>
References: <1757967196.153116687@apps.rackspace.com>
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com>
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local>
 <1758037938.96199037@apps.rackspace.com>
MIME-Version: 1.0
In-Reply-To: <1758037938.96199037@apps.rackspace.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GO4FVrkz4or8qYxFfHANEIM0fdnLGF-bD_nFzOJgPzA_1758039210
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ECE214000E
X-Stat-Signature: 1dx7q1eapqhbj7isz97zmoz1wpoi5mhs
X-HE-Tag: 1758039214-746245
X-HE-Meta: U2FsdGVkX1/ZRJWM7dWAB+MQ67JY7NQDYh/PEKCZVFM1kht5miE0M/nO+SQWmyJDyKj4Z9FjU6uUclCD9btRnS1y8mbWqfAyKe8HUl/NKEDjNBmkLsAmF0iLvzXJAMPew/9PJT0mfgTXBTIxLKFSjRLGS4GytNFMFX0tw4hdjiE0uM9XKMyY1GWPdvoGGEXjP7vr51WlDh6GCUPBWRZozpQC+SyqipWvIlB0Ey58cmW4JBiIrQHOadk5JJIo1I5am8rWYGLdEJt/nZjUlQCp7qxrbL1ALOCeUUzYbsYn5dKrjRmnWFhTevjT8b7JsG8XYKjrN5JefpU1PsKflhaM3jz4myczKqOkEXRv0cagEdZQAZzH/euMpDMokTctCY5zxmMs0StkTen79u17X0naWVHJxL5SB4a3RZzKEwBVD/wo++FHnPWxVn1CpUzzolgW+2O0VmH6/m/IGF2ipM+jep909ONmrmPyGiEdFXbDcTKUuN7voKYrxvKQ3Rbdc0+VZb67uWiV6WugMs84OJe61oHm6O6fApOIX5GLxjpreEC8SSNyWg6T9yppnBAN46Sv3mgGhhEcwuA2bDDDqOoTGq0F1UcrSr26GpuI4XqHv3nXWChJOeia3Bso+2uK76CCw2jprALiFRuHz+87mY0Q2unUHm3oNbTLOlWJKbMByrAFVO1cH7XtF1uui17THw5XKcOr8xLxC/6+7VfcrbcP8S7GQQhNEOvQk3OwqvW4/BObr0zMDZyv4FpIDNjTeqQf0CFTrb3PgrgQIAofc+C65eEnBC6TNQFznAdj4H1GVpQyJBnnddN3TDLNHrAEed0Q1cWu0yI0WFETpGoQbiCD/imoW7N7tdGhqpu6Xk/Qcu4Meg27X8AHacV6KkgqKYhvc9eQTFanZ2NL6EbD8zxJ5RV3Nxu2dqHZojVpu14COPRPlcKh5ydCZ+sd0CwQACFfltPBDdc5TAxGucNRiep
 d39acIdQ
 dFE6UFfFfcBKv7WmTdJ+0ePXfiLmd3Qr2f8GjhYXvUlJgrEA7v5Sc9pN9bYt6dcOGuWUFpNL7+Vz6lSt6shG1G2AYcY4mvaqXj0jSg9l14n8t9vUliUjqifEEfwXOhleAsw7bDqPwnCHXygrto5ECywYj/wz5M19YZxU+HkWSrDvicqF4szyg1BZ/7Wb87AqWohNsL+/WAIXBm/YBk+Gb94UMonass1D6XYc4IpgTARxzXeuNEMFVNN07Up/KlqEBedCFGeb5T8FQcAyL4xCl1pn6sqST14zvE5gGpdWWh/2uURT3Kn5WAMbWECtM0ZT18Ddc9adx7yLWonE2fR+oXOCHcK48U4ffDC7HqdX+e2FWIa3cca+2kk6i/ZrODThxx/HWU9f+ckOcFqLgXaTDpJdZCyqz1/NVCWHS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:52:18AM -0400, David P. Reed wrote:
> synchronous would be better. But what I want to do is at least get
> notifications of swapin events (including the case when the page is in
> swap cache). Also, using UFFDIO_COPY can be useful for the swap in case
> might make sense (but rarely, because there's no way to access the data
> that was swapped out).

Some more info on the use case might be helpful.  I can start with some
more questions if that helps.

- If it's about page hotness / coldness, have you tried existing facilities
  (page idle, DAMON, etc.)?  If so, why they won't work?

- Assuming it's async reports that can be collected, what do you plan to do
  with the info?  Do you care about swap outs prior to swap ins?

- How sync events would be better in this case?

Thanks,

-- 
Peter Xu


