Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A50CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CEA8E000B; Fri,  3 Oct 2025 09:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403E48E0006; Fri,  3 Oct 2025 09:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3197B8E000B; Fri,  3 Oct 2025 09:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0FB8E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:21:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB43C11ADAE
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:21:23 +0000 (UTC)
X-FDA: 83956864446.14.0E73235
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 934CE20011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:21:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UoKaIPz5;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759497681;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEydH1jo5Se5kyBydip8SdPrTJcyroKtL59YbuJLJJ8=;
	b=VRWS5GPj9NseVU8l+7RIxFT+edSnA2IePrO/fKIYGkZ9OI7plCdr0bqdxD5yFpCARDlesz
	8tpVrq+0pi/GRyW2pJQwcRqxm/G66ODomxGzf2wNLBdYpqYoAF0DMjQwpdEJxr4C+kHEL/
	9BjIytqAlUTTDVNUaaIQ3NCjqV/mzfE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UoKaIPz5;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759497681; a=rsa-sha256;
	cv=none;
	b=uPMiSbU/jvf8+F3eXYStZzXoxHvp9rBo4GYUfZH5M7aMhgfsPyhtP6lCo9Ru189PHdrCZf
	2GqP438ItlJA05DBgB/D//fD5jsFp03e7zo8aGHMfEUyIv8YUNH8Zcckl0q+gdcEinwGfT
	h4+xsaZLMtOgSsBg7KT2/OeowIbG3Ek=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b07e3a77b72so567226666b.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 06:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759497680; x=1760102480; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEydH1jo5Se5kyBydip8SdPrTJcyroKtL59YbuJLJJ8=;
        b=UoKaIPz5XEdiCeCMTZhyD9bywZNuowSSMUxL5Gncn/rqiuOLU7atVIMOlsDimB9dXJ
         X5Mkvrv7DEc9xFGj9YlSySNLkNykKFUrORNyPzdN8M6xilHn7HYUwsCBu5QizVloKcKM
         ciM39yPEjZfzr1//X4syLhSbVLl9vXxlbL68PUAGqhq60pANS7I6hrBcLJkKzuzkGxrh
         DINIR2ZA+yCBcjQf7AZmkT43zf5nRutuim3LxO16GONikUQ7JfvBBbbu/+bJRCGBhPYf
         q85kCsZWLCwUEShL8EivV4IHg52vzbCWcXuTNiW7iYs4UFGLleU4kL7J0BO6OP4YLCjG
         HfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759497680; x=1760102480;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pEydH1jo5Se5kyBydip8SdPrTJcyroKtL59YbuJLJJ8=;
        b=vjyx14WxICe9uEU/xI0SYu2rMVekIfu2OnVeNsYjTz9AePBfwqPMrzobqVUtdoa67l
         RNTrryyFHGNTqeK9fMxnOx2AAIc8wIQSLDQSDIrmar3+tFKu2qKEbJ4Io2xf8xg2ubna
         LH+UeQsZRX4sdBpkfHZBYLUMdMnDH9EnpR+fzU43NL1PWeKsxmL7rtGUENCqAc3CScxp
         VYjIdiDuy9Vo8RRmDq+A/BSW5LxXmBMRNB509fr1+9riIa2HcgRDH0ecUKi5C6l0tqtR
         pxbnr8xB7l5RCN8zTX/ijVYxiBjlrSgeB36Jvb4fWFSM53Q8XtXOY6mUslPtg8CT5eHg
         21ng==
X-Forwarded-Encrypted: i=1; AJvYcCW3GGB1B2VmVAWxyGh0KHPQe/6KHPCuD7gARoI8o3SKOC1CvwNZV3wkoz4DoEnImLlt7m/mN3IG5Q==@kvack.org
X-Gm-Message-State: AOJu0YyQ9iQ8Kl6nq3PtMVas3Lg7YtacD2oOmloY3f9oKhviFjbUdDyG
	gGcAfvSYng7ws7KwyIadVdKDh14vqZnZKkh9yKbcynZcg0Q4rDv6d0bs
X-Gm-Gg: ASbGncvtubyVlrN8PrFnCatfZEP906ivlX07JvVXmocjhnqt6uCqTShN7lSu/vShoj5
	x817P46OgHao5qABm6aiYE+y1uejR6+eB/fJ7zDBF5bhfUj7KKtvMZLeWugEo5oKFDfaD2/deXE
	Y4/g8Bs9p+lEEZKQFbcfC99Zd/zClUerkrrA+rQeJwdILWlDFb+a++2APHg6vI/5bHZWFQ39hb0
	eNms6ruxhldKNeKsfCkFRYL0LcssbMOApVJCSBxiGP+A6q/f525KFB8nx7O/ZVYPDNRsRzkNr2z
	sW8DFJykBsjOlHR3N3o7ovbw9DJdGNpkjyTHsjCacRqBv5bYROQWgs4tWKT992A69XP9ORmZzYd
	vIXwvotA4x7FftIqF0K6gCpIxTGVd+h1XS7i2psRuneCQuZpW0TKM/+6hGn5cY0As5hrb32I=
X-Google-Smtp-Source: AGHT+IGa64G0qwV9Bk1JMsFpkYvw0NEXZMFhhOg5F9dy+OS5qHXCxq08mh6HOFbiqmNQxCE//fb+4Q==
X-Received: by 2002:a17:907:1c85:b0:b40:c49b:709 with SMTP id a640c23a62f3a-b4859c7a718mr816247166b.8.1759497679749;
        Fri, 03 Oct 2025 06:21:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869b4d9f5sm447012366b.66.2025.10.03.06.21.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Oct 2025 06:21:19 -0700 (PDT)
Date: Fri, 3 Oct 2025 13:21:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
	richard.weiyang@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/2] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Message-ID: <20251003132118.qe2wipbrzwkbaatq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002073255.14867-2-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 934CE20011
X-Rspamd-Server: rspam05
X-Stat-Signature: zperw4r1hxsjmxaonuur8owox74forra
X-Rspam-User: 
X-HE-Tag: 1759497681-933809
X-HE-Meta: U2FsdGVkX1+wACsgscj1Nli3Sbnwez21odu/qyb0d3uy7TgnUhTSSHHb95mzRriuue4cngG96CpePeCA39vn63/+S1j/C6hvJGTR4BQjQaFtUHKi9vVjcb/ypUeX/oICyjYPWfUZFLNVhOg9lntrwDCEalFruXP6T1vWv05JrmBckpKDpx/juA18xJT8zvQnlHDp0zyVlDIdMINZb8WSr1Jk2owjrtgCI4yTRDgqohbFoFsRdtKmMIh6Y8chKq7lJbiWlaVzSJANmRwcFdPhYonndF2UqmrtjL2YAxxjcpe53IxvugVmQCAAwgILlzb1PxOT+Gm5HUto6u9tBazhnH+NUAm66NaaPfHO4KF0mDmlP8VqmliwVyweU+MyaVBp8UD5uuyCxM9pvAgm7yKQxjgal0DaHSJbv52uMpyKTdbUq9QDLSiCj7PngRvqNOM8Ys4UVFys6OyxUPHoIuuiRixfaugTxUwxvZp61aYhkiguPQTp6HzvJ30IEzC83Crth+JPi69uKuqhvfIPJdv7P0iq9ogJG2xFO/VGVavpkYdy7/SbTQkLH2/9/BxYGF49bLydHPBlEJSgqfgPhMj7lChv6nRMeR8gXXq9mCTIca5SIVtik3cw+45PYs7NhV6Jfcbx0pnDXdNkFGfYO3HSuDDYcSzwnhHZ1EuCiT0YDh18qa2sTBvrRXazcb9AaER2tyag/HwlOBzLylrVuhKCqAAVWv6oJpdfaHhLQcTnu0rfxRbOYywr+uy2Aiz9Dnidv8cyVEA0HJuY7PiiW5/ShPmmh946Sf+UPC179FnM/lGJUHwDvg+PRPdK45F/lD+iD9MG6dkzbWujDQGd1q3tXo9FkaLggw0o3QU+W6NonIFLO5wZYbbNnRKE42wyjfN+mj7LMPDyzn57vFFv4al7rgraGlv7xIvrkB8tLq1ydFqcQZ9Iw8uAYkeikXk4AwpWzsnDzZwquXU5Jvlmr4N
 gfoJDvwG
 +koHceZk7NT3j+BWF8dWJl6tB9XcKh59paSIVVq21BkIFYr+rY8pp1jvo4PJH0iZxm3y/QsTIC+LY15rUwnTI7CFIayzBGMbimU6a08mgiOtMM1c1wS8bFYVXllU9wuPrUI/3pr4f4th/MGEQ9rZtZiLCtVOIzT8K5adu1q6SxYeBsf47j1fNgZkkt4ufi4C4s7R1KaRiArxrEmT3XIN6qKGp5JYTwHDcnObFx05dMjjljOKiYm33cGZhM2LGZQeRHjoimX9mCqfjRLcSUMNRn2zY+VBkg2xFfoJqilanVPjRjiTCl6xqMFHjX2wyQiSbg1ZN6mwOVINRA97GAh7ps71ZQPWlLiR/5sTMuYj/oQHqY3ZjOvhf35IhBJ7GhBCN6Ld7tX76GwHZKG0I5en/Ss5S+HaUKXZYLYx238TMlcBOdohI4nPGrqSwa+9HlJ2dyvUrlU+ngR4Ix9zXOzUvokSKMYgyHwHTUBDvlPA5YsJlHrGRxPXHVwHX4EoePm+yMXmCvXRU+TmqVJ9feXIew7nXwE9njck4+FCd37PsOIxiOzFkNOYVlh5PEBQ7orlZXAP/64SsMOKbYQEP0KLGDQV4uSN1KS53Vtk0f9p6zPya+y7XelpvX0Fjx6og/FkTpg+1EesgOSOA1jyY0v4ZxD2GkaoSyZt+xfhXjHZmHjeSuTP6vwhdoVFSolV0uhA32HanZzCp6Wq5yMykq0rTfy6y4+j4waY8VuRjn2KjH9Q3tDrm2LyIXWVahjMRENoyZ72JjaIbDdBN3Ldxo52Trd40/2NgOsR0/S4LKlJzY5A0YyaN8CTZ2OB9hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 03:32:54PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>As pointed out by Dev, the PTE checks for disjoint conditions in the
>scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
>and pte_uffd_wp are mutually exclusive.
>
>This patch refactors the loops in both __collapse_huge_page_isolate() and
>hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
>instead of separate if blocks.
>
>Also, this is a preparatory step to make it easier to merge the
>almost-duplicated scanning logic in these two functions, as suggested
>by David.
>
>Suggested-by: Dev Jain <dev.jain@arm.com>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

