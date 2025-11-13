Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7974FCD6E74
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B198E0007; Thu, 13 Nov 2025 10:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBC88E0002; Thu, 13 Nov 2025 10:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84678E0007; Thu, 13 Nov 2025 10:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB418E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:01:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ECAB5C2BD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:01:35 +0000 (UTC)
X-FDA: 84105897750.05.03B3837
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4AA4010001A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:01:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LVlJVqVk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763046093; a=rsa-sha256;
	cv=none;
	b=rADYr98MasxfJdwgopXAKUnNyoSLNyqCIAqeMsSOAgi8I70mEFUSF/CjhNPAnQbB4xDuIN
	T9lWDiaZX48pA5mQsmLQ3+wy/XMHsckPx/74rBc4Ls2EPWfPHRJerl+e2tlvjViw1lRQJ2
	QEnU9zSPQhSnd8u3rWvih0/dEnHMVDg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LVlJVqVk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=cmllamas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763046093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/SziGgu+jV7pu6XCcGhbgmOS9AguhsMW+n+l2AM6CI=;
	b=u1JUsm6n9um6SrgERG8Nnv/bKEsjXEEZHqM/y9g1CQMNLZ0dPDsDZ5sFxJrl7uT6xNSG5P
	BP/KUgvYMkyG2tQyqyrHytYBsTX0FuxPqh2XI76y02u3JJuXXVKsoJYH7mIWoeqqZaiS1C
	cRL60+YnNO2+vySep7aDF6hmyUfzWTo=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297e13bf404so218625ad.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763046092; x=1763650892; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/SziGgu+jV7pu6XCcGhbgmOS9AguhsMW+n+l2AM6CI=;
        b=LVlJVqVkrLR0++BWsJKFr4SA0MRnR+m05Mi5erNH2LzKPd+ZnUmPfI0FoMIz57drx7
         xPpQUVdsAlpc3FXKLFW5ledwVrpPVpxOuLBuWBfD94oNFJb7Drx9T2MFkFP9OtKQniv2
         Iv8i+phM6wnfju4kS7pFO7TmvTDK3sIDPQSLNcto2hvzIUp3/KjAYdR+dgrwun1as+uc
         JxMzCVHP+mX0g1Kh617ccdYMe/jxUhnEOOv/HMPVb8AsvzNCOdDBCc5QbdYf0bHsiSDF
         p/+ZIEI1jVkdmcr8ALxqBAwR5ys+KSClkzp0lVnLkh8S3xxJqDkBDt3eJp55xZi4i/Ki
         zNOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763046092; x=1763650892;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W/SziGgu+jV7pu6XCcGhbgmOS9AguhsMW+n+l2AM6CI=;
        b=FvpJ9oDNXsVgmaOygytnysIVnxEv4SwSndNAZw8LDcaFGpO6xYYhbppZAZ0zHJaxqY
         sipKkyNF+4t26xEkghulTH9m7XN9ic32Vws8dKIKES+K45pClYF8K8uGszSr8PQ23Baf
         VfRfXXUzLhF1zB0awwd9CeABvtgR8CHAIAHPdwDL3bZJumsQ0NpadyPEu3F292FbhhgT
         FoliKAywLoLHJV8TsCDA4O6Y91pXSheJjVXTFFK8TpSRnMo3GuHCRMUOwH31y2A/2quP
         aRQz8B8mZkCrMR7J/hfN5540M14Bm8mJxU9lRhsDDIBHF7TKpeTAssrBvFVYQtMl25qa
         THMA==
X-Forwarded-Encrypted: i=1; AJvYcCWyo57DLQIAY24pAclj6VgD75OYdda6jgXriOuKT829oXKWc5shUUbKROgz5PMzy69H9QiTjC3QLw==@kvack.org
X-Gm-Message-State: AOJu0YwssfRFLfGtCcYWDC5x9i8gm2kCv8MPu+BUzQ8CGlUfTcdCDZqX
	QMYuChDX5BMUe2Wnf0oJgKKFX5Aoifz2Nb2ba0BVKjHyOCHDXE+n44cywODfA6U9Rg==
X-Gm-Gg: ASbGncuZXsy710xzParYISet16Ooo5hDqLL4iRgYRK+0JC41F047duQpt8pIyWa3s2G
	TcGdD36xoE8Ni+OEVGlHF/PDfc2xV1vt2GL3LENmcTSmxt/cQMwfRRfKqsZsL0Wc7N8SBUIB6WC
	jWNUDD4fUyZt4FveQgeWABognYU37MNjGGmbbqQxlK+AfKXJmyJYD2nT9EGzkVnCHJk7ItBXorH
	mda9suCRA5RNZXQptiG+I7vrOoNkzxHKR1IZEf3GkSKLO66O4nF44UkgcfY1Cp6rSF0y/LFCfmC
	IkFzwMjDz4/f+kd4gvDWv7vqCDtBU23XFpWmZ0bvotJxxul2w/n3F0jGClOAWabI8Qhr7hNnrVg
	K7uLTKHhwq4e7TcYHDA9qEqgvesSZUK0gkv5Q2i7mYYF1MjaIKXO2tY/Q5tJo4z9vkG6s4YvfrE
	5GFgzg5XmVHDViDAGoavSNHACxLbIhafx/urmhnNHvuSH2xcxR4nWwCjn0lUSCFBpy7W9txgSmC
	v2lzYsMPq1TVRMizsWpBC7OGaqhw9s4R8euTL6SXMqfmyA=
X-Google-Smtp-Source: AGHT+IHdr8Ij45kQ70mHUK/k9cB73vb7jVTWb4ZvM7UlEaVt90l+E+NrBr9d5OiWsFGMZC1NA0oARQ==
X-Received: by 2002:a17:903:41ce:b0:297:eadc:3cd5 with SMTP id d9443c01a7336-2985c45434amr4335235ad.15.1763046091379;
        Thu, 13 Nov 2025 07:01:31 -0800 (PST)
Received: from google.com (116.241.118.34.bc.googleusercontent.com. [34.118.241.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c245f8asm28347325ad.37.2025.11.13.07.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:01:30 -0800 (PST)
Date: Thu, 13 Nov 2025 15:01:25 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Brendan Jackman <jackmanb@google.com>, kernel-team@android.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - USERFAULTFD" <linux-mm@kvack.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
Message-ID: <aRXyxWeh81-aTHaC@google.com>
References: <20251113034623.3127012-1-cmllamas@google.com>
 <e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
 <4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local>
X-Rspamd-Queue-Id: 4AA4010001A
X-Rspamd-Server: rspam07
X-Stat-Signature: p6eqfxmws74go3bx1z3ioucggrykxp7i
X-Rspam-User: 
X-HE-Tag: 1763046093-251210
X-HE-Meta: U2FsdGVkX1/Zb/9ZujEa5kX56IXKi0ECCP5hAM/wY99k9xXacgQSnproPvJ5r8DtFJVJiN66zJ5kks4S3vNmpLY6RvzNDNNbIFp8VVV1U3ikzAn9cyRfklPjxsSIBpB0j1j021vq/q1dOAyYXDAcYSlsW6br+Z6NvjoCZDQL48Kd6jzBRHntjqEHiq28ux2GaejLBGKswderLOyR7+ESsI/oTMXYIQApP/uK8CQJMNzgwmjH3Oj5DT5+90qZ9xe1aSW+wgLYQejeZ8YFEaRDJke/utKbVN5O0ZuwybwaPZmAobDRIIEpnuD9menMAlYbdwC1W2bU1xRN6FR/HZA+3v/+qYR284CKIzdJn8duJGs/nkC6S/1H9JHzoSZzzhvsT6octEwDQOTVJerF5J+LxqX7WD+il/VIZxQIRDZdoKoca0cK+MMFlw0PiANvFD1P5ACEWoy0ZmR2hcCFTS3VyNG+uLLNMgPbs9pTHepaAgq0x8fhFjOiwiZWWZ7kEWKd4LInb4l1NYiQxC8Rf/c6McNh4a4JDldndFsfAhml27Wq8V49dPY0lKolPYEvOqCvJY94nezxSmQzZNkr4DwI53JImS1RvAWLfAtJhZ/Hd1ZnbAa0yP+GOe18XKzpiQRldI213n3ZVc/lJR/oWIMdQcnIVZEF34frzZdm1eitYgEPFZpoKBS9CcignSfagC0f92vblV36DzrlGEUkp9s5xyaCj4iwScNV4qJqvZ5nc+AdukypXJoGr/ClTlDHVeGNYZ5vUszybB3eLYAiwH8mxeEXEW7B9Ho5aLuFnro377iDAy61ZqbwtKlUDmI2oEtS+Q7M5yLZleuOpri8lP4EMHmzvxKlGqZHuCME0HxxllZqqrEToHvS6UCaTlVtwPh1qWvtAL5rqdBspo+upUJYt7wste2sNm4aFMfAw0CUhN9uxw0+1SYhW+nf4lHYLQBlkpQqj8hms21omYauUAA
 RSkLzY1Q
 4oRf5axEK8TQmJZzpbycZ6FS9o+Z4Rzz/BpXr60ZDu5W0Yu3HSw8sjIyWpyE2k6YJqZj3OQl/9a4SAKCdLXGQvkZy3O3K74Xjnyn7xuYyuuUbVSLv5NX+yUp9QzOpuoNRMP2up+GVYg9mspGBmDhbn6yqX5OGLiJAcg0b/Vck6bCkQcLBv9igXVtesm6k52BRceIe+uvXGMhG6bZATDkqaXhW/ttQdS5aPpf78iwZXQUHQhMwq40cxv/LVXg44LHRinTBQ0b4RtzIr7amhU4sEWJ1bWm7zWstPvx63gvaIBs78IxkC5lq07W8efb5WTpGT9xB8Mn+XOHMunpKyB6T+EFC18BAenTG86VVVbfPkYzT98FPCoJsf6ybiUGcBfeIXKb34jrZlZ/qVYQ2ERW8ReIqsJ0if1k+roM4E8phLfAKMQJJusaZNMKfFarbEZRJ/3gyu3lZwm60PIo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 09:54:37AM +0000, Lorenzo Stoakes wrote:
> On Thu, Nov 13, 2025 at 10:06:42AM +0100, David Hildenbrand (Red Hat) wrote:
> > On 13.11.25 04:46, Carlos Llamas wrote:
> > > Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
> > > vars into struct") moved some of the operations previously implemented
> > > in uffd_setup_environment() earlier in the main test loop.
> > >
> > > The calculation of nr_pages, which involves a division by page_size, now
> > > occurs before checking that default_huge_page_size() returns a non-zero
> > > This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.
> > >
> > > Fix this by relocating the non-zero page_size check before the nr_pages
> > > calculation, as it was originally implemented.
> > >
> > > Cc: stable@vger.kernel.org
> >
> > Do we CC stable on unit tests? From my recollection, no.
> 
> Yeah please let's not.

Oops, I keep getting confused about this Cc stable thing. Please let me
know if a v2 dropping the tag is needed.

--
Carlos Llamas

