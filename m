Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993A3CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07078E009C; Fri, 24 Oct 2025 10:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE998E0042; Fri, 24 Oct 2025 10:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4EC8E009C; Fri, 24 Oct 2025 10:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACE8F8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:12:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65ABB1A0EAD
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:12:06 +0000 (UTC)
X-FDA: 84033197052.12.9A3FD73
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BC1BC000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:12:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FmQIX+m3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761315124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxjAAwvJxcKyZkTF4DfQc6OYD277RCMtejBYyIJXDsE=;
	b=IrDkN4uyt8fCTyOKY8Ar2YY2PcIsVSjO2Nxk8wFiNmPmCgZqnOyBY+8HK9dp1tNXeP6dEz
	GwIG1WLooaZasr9V+0VXV17e+ytjXxnCll0HCS4Xo/MQm6uayK/11GaZQlVk2rV3FxYstY
	9pm44Ovqx5o3OkGRfvm/EGmNZ81xIW4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761315124; a=rsa-sha256;
	cv=none;
	b=t3nm09Dr1+2UbMgusl2V7qnd/9Z8r3uxJm3TXoLC+mIAEdLKnjr/yJWAzQemr6wVoGBZOI
	VpbIa5YobvUr1k/j1QPqDlmwBFSQ2AvauXSW6ZV1Ea4ws5F2hnYHBw4hvmdlD4elbBVZBl
	gOb3yBbgeP1sQtWJqTd8V4OVVACPtDE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FmQIX+m3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2897522a1dfso20865995ad.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761315123; x=1761919923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SxjAAwvJxcKyZkTF4DfQc6OYD277RCMtejBYyIJXDsE=;
        b=FmQIX+m3aSY8RPFaoUsIm3P96V8/Yy3MXscJ62WTw0+9uPmkBcR+lX1xFtIFzng1/o
         HybUT5EPWmtOhHECSqa+/i1dAXpdwLihVRiILoE6HbzK6OHgOuvudTF70GwXT44RJ5fj
         ZF1DYRUm13C7lIUB+Wk4qIn44uWeZfXSneTt3AS6ahn6BW+uuyw3NTQcLk39tJC7b/pS
         dZHrF6Zb8paMJ6qsrhnJJpp3DkAycudv4ufqo6kByNJG0HcKIc/0JW59vBM/juhsg17X
         9Dw6jbc7GTJl+ovjqw3Ryxp+6mPkge2V2lqZbOZkicO9Uo14gHZNMnL8CcxawsAMG8P3
         Utnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761315123; x=1761919923;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SxjAAwvJxcKyZkTF4DfQc6OYD277RCMtejBYyIJXDsE=;
        b=kmnHWAIrEw9cs1V4eF6Ea9AeoV9LduAIbaYWmtBuaEhDrU7D7JTpeBvpOprpNs/BCh
         FvrRadSlrrwnQ3qrozr5laO03cHsBZTncXFakXBeEoWQ5XumylEPAfQ9RfK9JGwSIDuZ
         LBwQYWQMZyeSt9aEED1BYUaxHxlxRCD5/j3QokxZ/kYQZxrIgbKnoRUrKfL+mbuPA+Ky
         Uo1VAp+FK+6P1WySp+7VBOc89OJ4l08ZEDf4mV4r615OqItK1HisPMCwWEt+MUTfw45D
         Pv5E8PPFAX5mLyebc4CwuQtx/72yAUy/8ln+Z5/5govhdIKo+RYhNFKG0OAn6/XGOSu2
         OvMg==
X-Forwarded-Encrypted: i=1; AJvYcCVL584zopsz1ScFB7zOCU93omYW2S/Nk8l+O4SPb55Ff3jCOGw6i94M1V3QU9manJ0MUbnk5OstIA==@kvack.org
X-Gm-Message-State: AOJu0YzXZuEYJWZvrhd1E3aZSvPq1N4TutDQT7+hBOJxpwX9W46EGGR/
	n338dSw3DZQtpfbNqDIFm9iDOOlgFu691ac8ihd4uqgOHxvnoUxTXS83
X-Gm-Gg: ASbGncsotpD89VD0ZqZHBQVjyRfJYyhuCLYydpxPUCNrejHickJ5AkGe6AyUZqRF90H
	xSsNigsgzH/W/3EW8fBRKD2gUCKFY1/V41IR6BEBXZwLXRptoGfdicYy33yBtqlOjTCXHvpMfdx
	IVopSQqBBjKzFWKV7f7K5WeZaLq38l46gjS1F3uROTxyXQZsu2uX7wSHLTw7VRmGpJQg1IEXgJ9
	TJpcBU1vu74V+2Umgg2L/cz94C2M/7uIWUgyKosQWiG19F1mBYIEt31/66c0VZFGxiWSVdSdObk
	ulhznUpkwCtlPtslWtitAA7+cEs0ZXnoGNFtC4/dEUn06C/bGa5B3TuPW2P3wrsQ4fYR3fh9ZFq
	3wdPB43rzmadWNCCok4i44M1qvAxTDq75++u3R4iRiQqPxeR1Nngzl1TDZbhILxCc6jP3iglGdN
	L3KGv2FLl0+I0BRQLJiQSv/JBbN0IDh0v2VQxgz6UqZfEyECbMaRgNaBcMIuMBdT0=
X-Google-Smtp-Source: AGHT+IHvWUViWUbcO4jFDmrP4XCETisDqYKqzRJMqbtZ69yGInyTHi+Yd9XnBN1TIdB68GJvKa9mEg==
X-Received: by 2002:a17:902:e543:b0:282:ee0e:5991 with SMTP id d9443c01a7336-2946e0eb3cemr82154295ad.30.1761315123024;
        Fri, 24 Oct 2025 07:12:03 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946dfd05dbsm57178835ad.54.2025.10.24.07.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:12:02 -0700 (PDT)
Message-ID: <c45c71ce0c3dcd321807debfe580c86cc185623a.camel@gmail.com>
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong"
	 <djwong@kernel.org>
Date: Fri, 24 Oct 2025 19:41:56 +0530
In-Reply-To: <20251017034611.651385-2-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
	 <20251017034611.651385-2-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BC1BC000B
X-Rspamd-Server: rspam02
X-Stat-Signature: bmwtf179k5jb8bukb89sp1i1zyotbmm4
X-HE-Tag: 1761315124-211524
X-HE-Meta: U2FsdGVkX189/IMMiApGChnsG2LVndlQOS+fh9LR7p487t7k/HwL30Zp2IcgCRxccW2Z5Mb+c+g81Tqd/TvehWRNi5svb/Ja+3pdVK69OLgDabDB6fitUyvUlUOWCZ0Zlbe9YvNWsggxVLrC2nGpbPU1kOZSC6CfbEMbWGr4jZTHZGqWGBkMSMWQtqvICiMyyS5FAGV/ljGFGnHmPYK4+v50nrNC8jE6etuDFa3dUpY8Poy8m39aG98QQArQl+XGqhBNYKh5/rVp2SftGREsd7zuXeR9t+LQEF9ugc/c2gvic+paQvWDO93hjMQpl/mH7AE98ZpTfQKft9o2ZS+YuwDCohoZtZWQU+aNOLV6h4FYt9e3NALH28Tv+CvPBKSI2sa796xJfLAIbNon8eG1ry1nQVzFoDfSCeLlSZGwyfIwuGqIdiOrkEQuU108dZ17Xf3XqbG0HAbyKooXaQPmH93i4rvAFFKnq/YVhpbIK7oFCtp28LXzSB9KWkEKwt+dYECjfk9ob6PK1F2fDAkopHdzq2fmiUlAt/QNlcyyv+7GX3DBcVCwZTROqflG5NMbX3kvB+RXVnBBTIzf12WKpzRkMN5mMQwq1Zr1i1pAup4P7oxD3RupgsWcbwbPFNQoM8hF/7FlUUwHiRiEvApYp0R4VU35/6LJoBHllXqUdJwL0LHn+NVAh+MAhmDxija7R3Y7R8aphXtenfXYIyH8z3+RPodlKWL/NcSSBg8xJ/pfOiyDg+B356HCHEr0+hBnKoBOiAwfWpPsd/RbSien9QmeNkORqP3A4Is1SGKf8nW215c6NAFG+EogWJ4D1Tl8g75qaDALzEqB0cOCQnS5vTiejZI4FhZQpISlfq3et0tnM4CWLaZhXeanPYk4TqwPSq4xYpEO3JK6NS6KE/slGu/YUnbx35DVKHnjl/R8y9oAXhhDLHMkzAS8jZH/pTODboAr8cbLR/IfN6qHuAl
 Ankc6fR4
 o+wL65ft29jpChlCtANsjzbH3fqckNx3/U/RavRwvo8wnSObttnX4L3SaddKCyBf6A6pPfcKa49ac/ivgHWWmukJ1/ph8o3KkpC9cdpZJVlniKMg6sUg8hJ359R3t35Nc7duMObDqvUqGzWN8WYS3YPU+3rY2/sIPNBZH9U1RvjO9ZuRRG0def4Bi7xxVPmeAXOsiIsttmTTwbuzR3wjpTxRGeCAb+3t1wBoJ9o0/3Y4tlHvuXCzDZZJ4VsYA30fUQNnB6W7zqh9yDFJ2+J1GmewFeAJ8jH81ypSg66VeIfKGkoJ56wfvlPgOy33PmF3axWZAo4EqT8YOp5iNBoJBPjfYc2wBQBoJScNxspyChdsOlWSu99gtpWlR09hJWaXbr9ujp8MuncaTC/7FASnE+9W4RZ5Zg7xRfa9/Fiv1i1lV35jFXEL5FQDO+zgK/+EjisAWPRtLPnm50/d/bYy0/z9OCCaF6SuQNwnOdHfNfQy+rlwoZq+Rd0DEMZA7irYtF/FgCYo3l//Wj/Uhnt+rzJJLsx5IJT6f49nrYO23VPNZdRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-10-17 at 05:45 +0200, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
This looks fine to me since this simplies the overall structure of the code. I don't think this
introduces any functional change.

Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>  }
>  
>  /*


