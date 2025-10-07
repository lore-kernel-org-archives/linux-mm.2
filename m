Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00AD7CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF638E0011; Tue,  7 Oct 2025 08:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B78D8E0005; Tue,  7 Oct 2025 08:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCC28E0011; Tue,  7 Oct 2025 08:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8E68E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:38:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6D021DC071
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:38:21 +0000 (UTC)
X-FDA: 83971271202.27.4F374B2
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0491980007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:38:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dthN4S+M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759840700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsIwM1rNa5iCNHH9dZX392s+eSfxnBIqanCsGLwT5lQ=;
	b=0ly1IS+uoSnDCPNZc6+Zb4nAjj2gvi1dno7we4Hpv1keUicyMbDbECzZAqThREp2sE2kAo
	zAJ00OchPq4ISGBLdxVPX6U8XclWYYA9uHI1UGIs1eBZv3cI41lpgRCTsOrE8QSU7SqnZ5
	e5kX6e15/JOCKjXWJmJlTaYgHXiUoo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759840700; a=rsa-sha256;
	cv=none;
	b=g07C0m4wM3OIYFZqejZGMGqdf9Fv4DDlEH/wPYDg0FB8xGf8/I4gc35uHJRA2bRhI2LQW1
	3y+MBttJrmlqlT5gOOs3PSTi1OsinsDfRk73h3zoPfSIXWfT3B42V/Fs02q8fQES2Secw0
	mL6IVehI1YjZwjt4gM+BNvvrpzoUTTQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dthN4S+M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-854fcb187b2so716372885a.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759840699; x=1760445499; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsIwM1rNa5iCNHH9dZX392s+eSfxnBIqanCsGLwT5lQ=;
        b=dthN4S+MOFe7avwWW+PQxuUMUPTNPohvTUxmLeQ1sgzKAMmWkBQlhvK4av4h1RWcUc
         UIlKeQbE5EKv2CErssMcb7TA5eVdkmKBdxl7f//1eelZk/gjsaD5Byfz8yWmvNMQGGNI
         WbI2d6LzLgaFa9wtOwdzOYf28DqN0ZuEBtCPIFdh+y4jTXijHEVdPy2tO8PjjdQW11U7
         g0Ez4QBJ/PmMm34w3ToSyLalpUzG6fthUnTO3ujM0IBwZUMhsNApGqlpwqi+pG+xYz4c
         DYsuDREq9unxrC9VUoOqdx5kjNmTwjbRstre+FBnpR9EWb/V6SfzCzHuFMBmPj3dD4iZ
         EHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759840699; x=1760445499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsIwM1rNa5iCNHH9dZX392s+eSfxnBIqanCsGLwT5lQ=;
        b=cv+Eso1U1PP877xKPJcMsJTm/XCEKJ2PvEHehecjcVvURlMt2tSv/3QK5rIGXrJtTE
         aDVORX91nll88FccNcGcJV1m8540F4WZKAzGWJ2d24zn02OVa/9YYCpAuw5fdagnk8pn
         D8s2h73h96EIGlNSflSX/JWkRi2dmhc5IBYrPmgJN01BfJTOvaeH54sTCgBWGU6+UCmT
         en+iKFUW+Je8/U5nwbG9/ErVAm+9ohW6l3wJxPCdGx+V9DyC0Po0z+jfA//aEbnIkKXk
         MYQ3B5BioNM4kii49YtUw+XZxOYUYr+0Vbl7XqBbaTebsLNnz5OJug4INRYSWRzpUe80
         kiIA==
X-Gm-Message-State: AOJu0YwDZbOhcVQyTf5iEzSqREzX6O3/sMCdZuVzbi7QKQ5MgUauU6Ui
	IooerQacboA0mIyEq7aU/G8livji4y3nqQxY8Twzuq50HLEr2aCS3cHCtMsIm+s9NqSZUtR3II5
	0nxrg43HpmJOQrZ6B67BRrSNRuA34FzZSXo2rlvMp
X-Gm-Gg: ASbGncvgzibmuc7tZo5TwbXWKxSAFHZgd7aDqt4O0Pmct/Rt3YG0U6qXE+SDA4YmlAu
	P+uDUPtDJ73dGtwkXsJ+sB8p+aT5KUEhe7jcrAETV62Bw/BMJZuLROu94YLbPTTR1KU5CWu0fU8
	rqRa06NmKhiBKCZuCAHs4Kt36kF8D63Y/FECKRJrUZiW2tyCvuB3oZ7L+7aHmm1veAVG4VsvyXL
	GUQNf7VsuvQyVOlOah1bcHBXrv/8gEjHLsnwdcrXkKmHTfrnarVaVt4Q96pbzdPCuMP
X-Google-Smtp-Source: AGHT+IFTuvFup/6aRZOSYOgHMzmPKInOb2mM+AFT4eKtiR2dHo10cyPwLgW7Ut91zaMh96r475+Bo7+OYE3WJ5mO9ZE=
X-Received: by 2002:a05:6214:c63:b0:766:13cd:2988 with SMTP id
 6a1803df08f44-879dc87b72dmr223523866d6.60.1759840698562; Tue, 07 Oct 2025
 05:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251007122035.56347-1-urezki@gmail.com> <20251007122035.56347-8-urezki@gmail.com>
In-Reply-To: <20251007122035.56347-8-urezki@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 7 Oct 2025 14:37:41 +0200
X-Gm-Features: AS18NWCc4tz3b2pwcaWdYKFXsCEP1C_PqDgh6cK4we0MiE4kAuLKZX9YlRuuI8I
Message-ID: <CAG_fn=VguRD6+7oiiNKLXH6pGJr8Pzz5JE6abRbGGMBBt6Rgrw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] kmsan: Remove hard-coded GFP_KERNEL flags
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, 
	Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: kyjypj1ko4atg7k9r4jpg4hcjanwfypy
X-Rspam-User: 
X-Rspamd-Queue-Id: 0491980007
X-HE-Tag: 1759840699-889144
X-HE-Meta: U2FsdGVkX1/Vo7gkW5qrWtjhgXuHBIalMPOR9LUEzzhznkowKQ41N7r9vgMxPuW8ThunirnCwW8YmvYPemLMDctFvuX/FB6e+hnR+mqtgjivOPZsW/4Mq8unIYTWRvPZ1MmdYHhmfeMTfck+37aZUFpXS0ueS3ncod6wAY/dObMZWeg9/PQokF/kQznbKwf3fhmdeahZH4wcYfAGVC9ClcZFpOZRcJdF9sxr6fJXrvfBmBUXILiX9hWwX12Hqq1R1sZTUU7fEeCDMK/y5z/t5Ddi4PZd/UHAS+4J+NXdjD6woeB+RonNMhUcMS3CUtD2HW0sKXFzktJawx0sYjxfX3yRlRXKwDLiVnrDrgOYkgNSQQ3I0ot22zEUrfGHlks5DFAFHWcNSHMH60KYgqPOUK/+3SaefEGJYKXsQqJUoRyFtChwwqquwc7sIQIUfqHmcK4seqYl49x6ynd538dBSgVpDPonunWRZID/3TFqVi/G3yuWaeA1nNZbAdfsCdHYMuY9XwkgZdWNbLUGLIm3dC+zM/zMFzkraC3eqwVzFfMuJucPEgONJA2A9YQNEzFHaccwh2jxhDMdlBB9iWwrFsO5SLEB8hkKDU2un0flaLYGUK5/1cy2A3T1ibUQrCFi3mwUlBArbt9KXpZSQ0EJOpkU0QVwFLSSVp5pbY+XtGt+74trmJRq590EDz9uOr3KzHIy4AGs2IOS2Rc/pIEvP9o3SS9URoF0PTcNWxztfOZU7W+4T+9SCMbu3iZc4eGJCZ+a1XYRdgSBd+Avin/B93SokwuvkfWm8IyslKVmquurzSt9jzR3brFiHnaDpuDsGk5El6qxb6e6neFU54JtJzYufV52duRc9HHqAxJEJNYx/CvLDR38s9OKAAdntFuiOe5Rrtvec4gq1CaneOQmIBdpJW62U7oH2BiKUwLZVU2lE/QlNNuYhCiWkZVjbZGPLvWA9huwLJQFlI8YaZB
 TOOF+FR/
 Vezhh1vK+1AUjYzwPKtSRL59wPKGHEkQRb1Noyhd5fTa37xauxxA1Vhcwnpgr6bezXy82b7z7AC79tFspgpxO24BX/oPVFIHSoYC8PoCMf3MwH0TkSVU861h3e9M4vnpwJFgsE3FWMF/OW7QTaDgUpUg0AgfzoRSi1blUqd1GjxTNGpT4BhePWnQ4XV5Ps8FCuWEMdvrR/yMIZHl5mWnHq7auN+2UWBWB+Xx/4i3ETsH+4e1hoGiyRypUiGqPb9G10NhdRiDrHDkRcKZZ13VXjgSQ5jWTpiPj0/2N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 2:20=E2=80=AFPM Uladzislau Rezki (Sony) <urezki@gmai=
l.com> wrote:
>
> kmsan_vmap_pages_range_noflush() allocates its temp s_pages/o_pages
> arrays with GFP_KERNEL, which may sleep. This is inconsistent with
> vmalloc() as it will support non-blocking requests later.
>
> Plumb gfp_mask through the kmsan_vmap_pages_range_noflush(), so it
> can use it internally for its demand.
>
> Please note, the subsequent __vmap_pages_range_noflush() still uses
> GFP_KERNEL and can sleep. If a caller runs under reclaim constraints,
> sleeping is forbidden, it must establish the appropriate memalloc
> scope API.
>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

Thank you!

