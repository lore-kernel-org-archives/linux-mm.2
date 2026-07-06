Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BB4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6FF6B00B0; Mon,  6 Jul 2026 14:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E556B00B1; Mon,  6 Jul 2026 14:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D3E6B00B3; Mon,  6 Jul 2026 14:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B43F6B00B0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:16:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A72EB1680DB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:16:45 +0000 (UTC)
X-FDA: 84959157570.24.FD913B8
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id B18F2160005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:16:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=n64N9ycD;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783361803;
	b=z9obNrRgLupq/RsrFkCUStcL0pXx/odP7YgUwDXRHz45aoG1j8SrJlv3ZvUzZK0KHAYE2y
	4hQm2jLCHbkQhzIQvnU3hhLn8PO122kqhjh/3UyKmpS+0bH16l5kWKWw+IlP3BbtQ53vsf
	UL7OGm5wlUwFDGDn5zMTeF/EYZ0jLRg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=n64N9ycD;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783361803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBxMi0JruZRfOpKBpk8TTN47HygeQas2rW6X95AsLZ4=;
	b=u3Zo/IvY24ornvmZYN5TCh9pP4OVJgQQ4qqOXlvYjf8HnJsmDRXSlUkLGVC4eKqTL4qa3o
	lXvD0Kofp9TfYcBT4O3uydb4mGfMQLIh6yCDn16iAN0Wj6xkCm4ogIXEcsx9mMXyebF8qN
	+pvfIMBlqSw9Wlyij8DSGsEVYeH9E+8=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so23704566d6.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783361803; x=1783966603; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XBxMi0JruZRfOpKBpk8TTN47HygeQas2rW6X95AsLZ4=;
        b=n64N9ycD+5By/QykKECq/IJLaJplVx1fyqRgiaSgbC+WKyikmXQ5CRSVbqfcHt15Nj
         W3zyF2T+kFtrOQ8cUJ1QD1uYLD70eTGmaz2R0t80Whfaf/ZDIaNqyo7+YeClLyc9VrfD
         GfmUYa+hhcK9ZtE6++mo/o9ZxHJgHuut/YnRY8mTwyZWJhvtnY2IA9jMGwHu//Y/ssKu
         BFg6LZl+wfra4Uj/YN/PISJexYwTmxosDv/Q7sGmCLkB1B2U+LkICCp5e8ziPffRBSiW
         f5IDhFnXXEoL/Esq+yQAnYXrzm7HCVGsv8MGzP97KHsrw/BJAtFrQAwmminH0B1GP2yb
         ObOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783361803; x=1783966603;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBxMi0JruZRfOpKBpk8TTN47HygeQas2rW6X95AsLZ4=;
        b=SNs5HMEOag+291o1smMkXYe57uXImtvAArzHFjuvai0HbbqEtcQJ2O3gucNlnRZrAI
         KNQu6xcCt7zTpW2C7F1rDsoT6t+LM8SaZg1KayyNLuzyz1IySoIKdLejCh5QefLLEgxQ
         uttuF3W8F+mTa+1YU/fw5EID9+l2SHd3wJ55JuWAbYgX6oZ+qNUwj5Ewpw+N+HHtwdlB
         TiMxXlb13/5wRwbIUjJMbsteeNoScZcf/cML9cfmP3VI1W5HHpYQfz5Jak3yKAnKZI4N
         CuxXFP+L0MMXXC8OFMOnwIT1evRnYlHdSfgIL+ouxv+a0Q5adEmOAZWbn4sYoF/PZkxO
         l5HQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJibHDdpGF0B5HlfRT3edbSuWzbwZI6LSl7NngtsSCxPoDon/JSHyX3xZFf9urk+PIRYsqCHC6kg==@kvack.org
X-Gm-Message-State: AOJu0Yxd+RVttafJRiJWxKw4EXZnRuR+Oeojrp9F5M1yAUYRtSO8ScH/
	sAsgiamlymORA6wdZTw7TJ9hW3l7+0Z63lSDom2kKrGrTZNbrKdPgYqkgPHHtPfGGhw=
X-Gm-Gg: AfdE7cnHc9M++ldMdqOVa4Vzj3+inAr6aF0O1qnx5v3B+J2FX/lXrvne+RbbvZ1TRcT
	OYJYTfY24AuWjX0V48c2EcTnqMfL9eVr2W+9iZTzUrxM1OdTyQdI6Wn+u4b9LWgLrHPHO32/0RI
	tr30MhkcFJgIl9Z4faCpiUASqJxstZvESbafTMI9ZdUnnj6kRwUet43sCMxBqQcv0BEzGvDzQau
	Fga3XA18OyM6hyZUFb3LZqwwDxDkm7+XFk2UJoOLb3WlHrWett/Ba3uzy4FyHeUP6sTERI2mSZC
	tg2V2+QmupKcy/JvFIG9YKCvZuXccffSGizkHZEjn/On86+K+ESew14vjUG6BYLL2zsslZXzNla
	5phjfZdbtL0ao5y9fdGCccweSvH0GagJM8ixWN73Szieyw5ZivmvsBzV2GvFrOmvnWVlLaYo=
X-Received: by 2002:a05:6214:226b:b0:8ee:b05c:596d with SMTP id 6a1803df08f44-8fcb336e9fbmr21380346d6.22.1783361802525;
        Mon, 06 Jul 2026 11:16:42 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f4724b9ff8sm139929466d6.40.2026.07.06.11.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 11:16:42 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wgns0-00000000dbb-1jFq;
	Mon, 06 Jul 2026 15:16:40 -0300
Date: Mon, 6 Jul 2026 15:16:40 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
	corbet@lwn.net, leon@kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
	surenb@google.com, vbabka@kernel.org, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	longli@microsoft.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v6 4/4] mshv: Use hmm_range_fault_unlocked() for region
 faults
Message-ID: <20260706181640.GC118978@ziepe.ca>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
 <178336052192.504354.1841795575701703197.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178336052192.504354.1841795575701703197.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B18F2160005
X-Stat-Signature: tbu8nx55jxju1sreum4sjd48b4bdeg8r
X-HE-Tag: 1783361803-351350
X-HE-Meta: U2FsdGVkX1+YScPcTZBkJmHHW6LHjVR69drwuybTjAm1Mr9lS8FwvRD9eGNowkS+T8DgrysJYqQIbTqrk8J3bGKDwOb1OgiFhcSPuDaqUnuCEwVautexLBW7P3xWH2ryPr6gBAAqFst6CbNmVV/XxRAso2sTRjSPVdW7upGP9y7TiAJSLe2CPHR2EzDXgBAMrLSoesyiLAmAqrgH9HIg3ZeK2fhV2R4W14hQZnvCN3hAMSk7Xhl9sWyzmy2Dps/ssj4PQbfP2ULjbpQ0uJlMIyQ/TTyNXDb0LjTtxKCVy6OO5fn+XDy3vVYnLw7xpn4knf98IZurtPjayGYwHcekuV7G4jAkpV62zWq79JV0W94ceY5MVPwBFvLp/6HSR16GeThxPsfu2u1omaeCqPllBEewRG1xwsXxnf7ez+m3nWMjhJKjvIhQFKptGAgkhNW97uv3Pev4RqscWKxBrWviDaQMWCz13uypd6Cw2Dzv9cCtLfb/asoH61UnJVsn+x6/EuQMPVSgr2a1uqx4SK0Hm0g1PyqaRH48soRJxMxchuHKm/C+Y9m2bXatkEuAm9VnYwiQFOEp8Wf5AtKAxRV2UEdTpHSATJqVIe8pEZFk/tp6CXlv28fuEbBmJBw3nH0LqbRFIrqFzHKPzbuTSVfn+DW0nEoOxOq+rsWyb9mHdtdFTx3Jny0sP7PHib/9HhPchSCl17ttvomGncx+UWGfKvmdefsxZ7WaAN2uxO7oKUUrci9T3qYOHhFbHV6fbePRdtOXY6iAXWaC9+s89Ko0xuXLnvhV6s8IoebdjsOZx8h0nJ8Yrd7VyAuqda1hnisJzp1yQg+TKJSNVrZFBi2BdNvbJF5zTVKoioL8aZSfP3vxwnbg+wcM/2xmHxPtm9bGLEt/Cya9yvoymu1bROrspjcfQFT8yrMVg7t0e+c7kFcxU8lxzmAUymaFjfXYvrNtqwKz+/ZTFrZIqPvVqg9
 wAyZ8/h0
 2gJVp28yXw1+K9c7hTKyNKfBbFFwpA2DmDmvVx12Id/L3OC/nyG1gLvCRTNafSusVln9Bekdok7D1jEtJLnHNp7BN25UgCAfjYZLWRzylNPHtcGuHO1A2pDUE4g6R7M2Fwe+9EZZ4pXFqgOtedm4s3T9T9AC8Rsn+CeGiQHWC23EE7NGKgsoYDaNrK95fV8l+Mz/JeaGcCdUlCiftSBev0K8Y1E4zUgAHBzibyuZ2W99WaYH1dZUmuIq238MW6dyuzMn9OP6A8hxMKqcAUav3gcjwgW2fkc2KiUO2e47w+Sg9gNd0NIliEFX+DgXxZ5aOmuR/94RbmdnoJ3MKOtSgguTTXv/3eVdnw2rvzbS4UxXS1Bx1BHHRdm9cSxo241cP9bIeL6Pj4OlR4nYD4HjbU1Jo+dVuyDa2XpZK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:55:21AM -0700, Stanislav Kinsburskii wrote:
> Convert mshv_region_hmm_fault_and_lock() to use
> hmm_range_fault_unlocked() instead of taking mmap_read_lock() around
> hmm_range_fault() directly.

Please convert all the trivial users too, thanks

Jason

