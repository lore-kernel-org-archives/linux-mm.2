Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E32CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18E78E0009; Tue,  7 Oct 2025 18:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0378E0002; Tue,  7 Oct 2025 18:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE658E0009; Tue,  7 Oct 2025 18:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48BC08E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:12:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4F691A0294
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:12:28 +0000 (UTC)
X-FDA: 83972717976.04.DE4CBB3
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 21E5B80013
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:12:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XO/FZz5a";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759875147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebBRD6yGmAnfNTiFyWqKhtyfR494yORKNRgWYunUcoo=;
	b=2Ye0UoVrlk5Q4q52bjkZbjVzWbQxeYg9y8k6752rkH+ts/CVu9T6+Ct9qcg0vi5tsacGgg
	xUR9BSNOHvP9vJqoEv4rmXsQTHzFlHZ5QCTgW7fvT1QsZdo+7/e0kgbFagRumbmD56SZ4X
	Rg7kwYzZG8U3FLUBZpY1REwst31G8ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759875147; a=rsa-sha256;
	cv=none;
	b=3U9hgmb6EnqqnEI8Liw/ykBs4K5q3KNcfFlabo1melV71TmCVIgW/uuTqR7XLbgQJZNPL6
	wgovY9A+Le3kAO+gJGEKtJSe2PI+8gv+HyOsgE8DnUdfhvUsh852DjEJgcmpClKRSCnqQn
	mazTKzU8M0ZJzel7SLp7bOy6yguFoWg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XO/FZz5a";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-856cbf74c4aso839728085a.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 15:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759875146; x=1760479946; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ebBRD6yGmAnfNTiFyWqKhtyfR494yORKNRgWYunUcoo=;
        b=XO/FZz5a6z9i3Soxuzg1AYCCitBM8amVDm120j6gewT9rdo0jFgLXqk9q0GVfCsGix
         0wMuWlTo/sjC+5XmeWZ5+huXCmpKuoVTJi/iYEJh39/24WevkFJ/NLaSQGxYEofB889y
         GCVX4ZJqOMK3IDLkpeCMrAunHuGBKe9pUkfr7cuKq6odJaBrDt8H9VNAwLAe6Ni5ayv5
         FvmOWLDyWTQe8OpwRu+Un78lnGmfgDvRDWbkd5kbed8hEGhNaK14acspmBcn2PNlyL8T
         JLJ0eEoN195fjLItbGDTvnNPWjPK2KNccZhkjZFWtVPebhPPqB10tORfm1qR5GBvl+Jy
         vWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875146; x=1760479946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebBRD6yGmAnfNTiFyWqKhtyfR494yORKNRgWYunUcoo=;
        b=T94XYvARdLJUNQl/tpOn1LVUvwpLXlAwFUEqatK3a+xTdfX02SO+yzhm8C88KK7eDB
         dE/+LDp058v8Oq4Gf9XxNhx7KNRXLrPVMrxrjGMOswBxkMm2KpShziIf+qx/jPoZwUI4
         QgmNNAptsewDZf55ItSVw/Hf/3jdKWE6eLvdQi0FU3TZiGr7m5i4bK2h3lsSLP/DTzlK
         Rf5ktt8s7Y5HB3z5O9maUZhWmSCBvsKQAebgTXq5VIToqi5LnPDh+SY9oYyOHuwkbO/a
         V8tdfLXDc1hUz9S98QXBsOLLsRpj8nLzeKcMHkAPIiAFF6V5V3vQ0QmQlLhdO30ZM15G
         VZyw==
X-Gm-Message-State: AOJu0YzOTdg7jwxVqt39dDMCxu+Ll6s+IvsJ7eyVoWbX7EINQufz9tVl
	uYIGwk1Vivt7ixYCC0ivRhzPtZ95aQYyxOg2s+GdsH72opAJGABClxL7y3URHHhhoeY=
X-Gm-Gg: ASbGncv0IKhbzqNSRmUbQ+/vZEMpmPa4MzB7bcF/v7Asy+K8Y0wOM2QdEtDdHUoeIV6
	bdoZD15uOZ3szQK5su2E1e9Z5OZzfoyhfgpA+8trst6zkeDgK39JA4Vwu7AJj9aQdYvQdMfDYG3
	V5UGPw0WMx7l3hjoLX0nwbZn4IlNehqoUhYYlk6+fN23sb62I0/pFRiqtTRgZsncN+/ch9LNcAl
	C4h35x5s5AXWHHvUp41InA23l9cUwKNI5skawBCPo/jbLZK3nLcJ20Q2E9vOFQCkEJUNEowxoj6
	uVmLkf2/7QsXytzHe28wnUazxJz3cCE+xVEwAjJfGq5BD0Y3thk/caV2a3rOcznPO0X4Zxzap1g
	BCifeL/w0dThNyzEaOLrTWlx85y1LcYvtJapspFXFimo95uMltX41Hr1GsXPx875srMLzgRt49j
	5MtrqB6NSOC8wf3AI4MulGT70CZ+RcXA==
X-Google-Smtp-Source: AGHT+IGCq+eGhr6gIxsGpM2pRbfwzcvGwatmmJT+/kgQa0cOOL2MOn7JsQF2sMQyvLhQx3NeVxG6xw==
X-Received: by 2002:a05:620a:c4d:b0:855:24d7:5525 with SMTP id af79cd13be357-8834eff4d01mr214767985a.0.1759875146022;
        Tue, 07 Oct 2025 15:12:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-87779799145sm1548566585a.56.2025.10.07.15.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 15:12:25 -0700 (PDT)
Date: Tue, 7 Oct 2025 18:12:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOWQR9H2i4J8dZZR@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <20251007145955.31dba3afad6200e885e906a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007145955.31dba3afad6200e885e906a5@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: kgfkxohfyue9tu4zyf9q9ycshac1tf79
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E5B80013
X-HE-Tag: 1759875146-989221
X-HE-Meta: U2FsdGVkX1+/BjPEhfTAFMCBQ1eOsklIqizBzWrY07ym3Ixs/UXhHg4qCbET11kzwAE+obcYCE2OEuO3xvfaUczYtpcsBgfmBX+lOXKq5tNIPgGTSAISM5HIIPm7CsnG2Is2inOx0qZtyjY6dzOp8CGTKOL2lgVM2VKtuJTy5tWINgFp+BLD/sXjcEQggdj0BGUWRBmlyeK/tJ2iymsGsqQz8k5JlYDeVaRwYz+rOYFOygi2+9x1SB2oLDz1wSA/T1vr7NC4aM3KYfYhzDqcS4b+OVcBbY9EwkGZHYU2jBbaJBjBuZs2JiL34w+qykeTql4nGUMbRZJoKi0Xgl8IqQ99PTuX1WbdZQ82RFtSb/weDgNAf2rS1w6mPpC2jtsk0oiRACbLDCKkxHweVg6wHmozP3Lbmk633g9rmCJmQWLM2NoPTw9ZCdKWa04Iz0H3a9zmCRFoffwjZnM3Mi/PooegK0Nvmv5LL/Oibb9IdEF9U32IHIrzdEiV3PTSax6xOUTDmWSjpEJfP1eHR/hocN41hf6f1Qd/N68Ti0DTZH6qSzFm8JMsGuzvo1QjRJ+Vq12MUTpj6Uqk2g+oxd61J3zaaB+2BtkbbsDb9O+h7U5m5zPZbucdyqjscmaKm5/vIlyhkG4CVdix1Gj0xUzQ1dNbXTInFEzJlk92MmVud0B/n25k5vihHTCFYNbauXp7j/YLGiU5vAz+SXj/Jm/T7IMnLmx7exzklPOUt7FVh3FATtmGWJoOJL4IvlENqNd/7L8nhrNQHDTMQGA9lpwkjoHRhuQr7ug+XsIbI8zAlfJ/BeHxiCQEzduRE8CUWppZXZc1B+m9VE4Aa1HerA4wuaHzdmQtD0nmlRPJkIzHv4Pq2RGS4a80VACvEfhH91fCKhj/Ahk8xDXv65JK7bjpEuf8GEosIVt/qkGOpF2Ypvy24x968G+UItU9fLKEvpz8a0d9F4Vrzr8NqDapkL6
 /fVp78Tm
 cfS/FRgQHqKLQJSgftxQX9Nc+nCcqtxfmnJkvx1JHs6noiomx6p394vIzb/Pk1LfN5laXFNzPom7U+qhDF93IdLAoTyvWetGKy5m2Ridp+U/dm7/HVODn1ldfXfnwZgv93Xs32PacnoR8X08NJC+fbIWrRo8iI2hj+Xy15WFBuOC/cHrLcUOaji9Eq4DwbHutCd5ihAHKin6GCd7fdcQeZC3QhNnM6PmxF1R9foimVcCTRHgXDlkQeeKPisCZd0BcyshmWU0uB5wxbP9pHS2v08wb4UPVv+nuZvzEVC1oZFtcbnWpnDJaOXEnm5CHxj6EZiqogCsCz+7MTVUWv4tFw4IX5kOmGeLWlVWIBjiNIcSZrEZPefvZrHD2tN1CB8xELJqh+29/W3xjOcRafZIKU5E0vcjMpZiCusYXAL8JBms0E2dM7ZZJpVrzpdB+LNiklw7jQ4nW+JFckvw/f/oOKEw4wl5OOo/zRloP6uym+39CIbDOtwGW2/eN2NbMJThfHhmj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 02:59:55PM -0700, Andrew Morton wrote:
> On Tue,  7 Oct 2025 17:44:12 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > This reverts commit d6cb41cc44c63492702281b1d329955ca767d399.
> 
> It's been seven years.  Perhaps "reintroduce hugepages_treat_as_movable
> sysctl" would be a better way of presenting this.  Not very important.
>

But a blink of an eye! Will fix it up if feedback is positive.

> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -55,6 +55,8 @@
> >  #include "hugetlb_cma.h"
> >  #include <linux/page-isolation.h>
> >  
> > +int hugepages_treat_as_movable;
> > +
> >  int hugetlb_max_hstate __read_mostly;
> >  unsigned int default_hstate_idx;
> >  struct hstate hstates[HUGE_MAX_HSTATE];
> 
> Could sprinkle some more __read_mostlys around here?
> 

Makes sense, will take a look while I'm poking around.

Thanks Andrew!
~Gregory

