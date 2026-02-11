Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E23FEB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BCA6B0005; Tue, 10 Feb 2026 22:10:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BBC6B0089; Tue, 10 Feb 2026 22:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DA46B008A; Tue, 10 Feb 2026 22:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D486B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:10:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EA7F16020D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:10:44 +0000 (UTC)
X-FDA: 84430698408.11.F34559B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1A6BC0004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:10:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ISvADKd0;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770779442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otN3HWjoBQ/smxM0XlD9RDdB/oqUvMvHXQX1dEgOjYo=;
	b=w6/tzG5ivKQuB41+sxVFHr8vB7fVMWFZdbnGw3azTOYxuYNNkFaS7yh08PpcoIGpgW5JkZ
	6wwlgj4c9K78fkdNoXDHxfqyi/y70vDEENiwjw3JulMyjQfGYk1uV/MceMegTyRJK9ftnZ
	43TlkBIIdKNQ+lMKxfmVq0umj0STGuU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ISvADKd0;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770779442; a=rsa-sha256;
	cv=none;
	b=boIdfE3FETb/1422i4/i05k+ViVD7JxI6iRY5R1G7S9PlxVXCBdxF68Gc/e6bKqHP0WYLf
	9m1qGsV4Uz2z8L+JDUGw/mVdx4ZI7qAICiA3wuu8/Rj/S0pkR6cAnqj8OFtR6lDberuBB2
	TBefp98GOWdRpxSd+lyxqeC+AkkOigc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ab232cc803so3106745ad.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770779441; x=1771384241; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=otN3HWjoBQ/smxM0XlD9RDdB/oqUvMvHXQX1dEgOjYo=;
        b=ISvADKd0Jg0X32/tn8yTY4bgADtPz/iDBebsYdwFCrbEQ93UrYetD33tX3s5rz8Me2
         g7KKbFaFbkYB+OqM4+b4GiuY81hUCUM6p786PCsevhMrlOgcl5Bp8x96xG2RwYZkf6uZ
         4EOM43dPb9MN5Zh2rjj+xCluXPNAZ7woiYP0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770779441; x=1771384241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otN3HWjoBQ/smxM0XlD9RDdB/oqUvMvHXQX1dEgOjYo=;
        b=kjzn3JE4tuVBRS0Hsk6FuS2ZcZDq1e+h7OGDLelnctcGJXUwkEuiB1rBHoUeNv6Y67
         jjFq4qVteVF9xFcWnouqb6VE0oBHGVtEmq/SXqSVi6S7rgRYn/A/yt9ov8fnFymVABju
         UCMLtB6hXs5qmUjSEl4d77aFiYIL63yNLfHfcjjB87uAjofqYgPJCfCpM1iPyrA9IMqf
         RChHiYPU83inoJWSLAt98RgM6z9DILjfByycSM0ZhPW4jdYCbvFLqpMhnqWYZJll/HDR
         QOWF5Xtu8nX5gue+YRqxnwyXTMChdH1mzulRvAkKwS4sKPGNMN++aqR5h932zmSBzRKR
         d/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOX4JpFdNrjKk+wbrzBMmrKM+6iQ5eIHRTFD/9IDqauDBkI/eTkFsaossfbeXC/srGydrgDpxhBA==@kvack.org
X-Gm-Message-State: AOJu0YyR+Xn0cqLe76gMZcubcSwug394bI1SSlV+PcvJ80oXZXVILyyC
	halB/RGsypQM1WxwCs0khe3KxRNd4lYlMIswvKqdh1tMgo9W3Uw5IEadeeaQE2KpWQ==
X-Gm-Gg: AZuq6aJUKXSvYk1FJmpGvmHXtClgG3YX2sVLliSL22B9uisF8xz5EVeoKAbeoqQW36v
	NcT0APy8HlYs2jiwbiJgJd1jizl2/ySiLHREJM8KEp1nofzgwkva9Bt7uYLSQX12lzRPlvuGSoM
	4ry90g+1iFlb7Uxw6HMOX3JW3SFaVj6dg1r/FSFnqV80/8ecpnSlaVxaYR2q2+BeThb2iq4uqCz
	2nLcxyAftsRN96i95sVuNVqInV2+B4TKsUza/+Hbb1ub9cXDcWWIAbge0yHgzVSjfP+a80dmAVL
	ldjWouQtWpTY/YGcMaDM5uNBLcQVYoz9M9Yq4Nqdw5NqPAlFVG21B5f2q4oh7S2MnJ15a6KekqP
	7QbcGQWuiyP4jHiyU4oKkNAgL0m9Fi04CmooHF/bLOF9ILYcicL9TFT7HBv2yk1T1pfQXJjGk1N
	8tOCrrQE3QgMi8gmCGZS9uNGNv3VNVSutsqqBB9uAwJD4qxQZ/4zq1QrqK7ASlqQ==
X-Received: by 2002:a17:903:1b24:b0:2aa:d506:d189 with SMTP id d9443c01a7336-2ab27f3820dmr12671865ad.34.1770779441534;
        Tue, 10 Feb 2026 19:10:41 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ec5:3497:e96b:e7be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab29965093sm5406665ad.52.2026.02.10.19.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:10:40 -0800 (PST)
Date: Wed, 11 Feb 2026 12:10:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: make scan loops suspend aware
Message-ID: <ury75ckufz7rf3n4ksrufa6baxmslwlk3zt6hwijn5dbnbd4os@ximgbxiw6su2>
References: <20260211030024.232964-1-senozhatsky@chromium.org>
 <a441c762-1f57-4124-93a8-aac55f32d846@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a441c762-1f57-4124-93a8-aac55f32d846@linux.alibaba.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1A6BC0004
X-Stat-Signature: zpmqoa3bfqeyus9c4k3udznq9mnesh17
X-Rspam-User: 
X-HE-Tag: 1770779442-375333
X-HE-Meta: U2FsdGVkX19DKu+7U7Eqj1+ENYCav+llu4UKVKviIEZ9onpI0IA4dGf9xBFboIbNzB9f+Hf5yQtIEfXYp81of33jcm+xPR/yzOj4sRhT7l4I9mA4C49lDt2FGVVeGcsfiJoSziTCc8NGPPJGxztv2jg5c7jNq4bqOFXTMIxxkfMgWMpTPvxHlM3kQ7fj0QJctCWTe56faLONdFNURU2tDGA8glBdxzEQCtpkC/njhzGQmH9a3C5m7Z+7+ouXlilfTJAJwYHtUcZHzJ2sJj+hMKHYpyqIQOAS7cJJ8E318GtJNKh5SLtrwMUajI9k0MHp0v51UeDB0BxIbMNNzh+KSaxbzB0xEQOeCN0UQ0a7BrEQ/uJ9YkLdx/hgbUMhISyUai8YzI+KdjJi1LhYfM39ciDtFC/B93k16VK3ixgxSZ0YjnsErJu1Pyelxl5YpRlmd/BKiNL1EmwCWejpmu1Y/x+SuiplEiTftPLUGwSwfuGqEuZaXkkpt9VH8TZ8h3l0IhOwVbYCQTsBxsaoUuLkgIRR/CIpDb1gJ1rJtVQ/t8MPxmhEggF+bDkfBwCAccHibEj7TEiLJ4mO59GAHZYW/azYZM5UNYezxhbaoqZ7HDAy+Dote9tfSZYdo41rPNFIK2TAhSDVCE8Z8AFzldZcwJ0kTc7K+D60qP9macwOYNhgtZ1yfnJGSV2yngaaRK3Y3974qvpSRCW6ltYzhoP1b1oll/xd2h/696S1CSmA2WmxPB37MVuUXuZUFBU0VLOXzftk/NwSmknRNkMe5w2wR8Fj6WYCLBLKzm5ZNoGTGSsuq80cxQ2KA95IxP99ysDLZiaI3r/7pFU2HGMDs+dNX1DZ5JbFdZYd5eA25qviBKbtcFlSYnNrDolFObnl1wpseN/S9AEmzqenIrHwZn3sbYVlm0gtVinODLmB2Zmw4LVwlbY2X0FTBeu/NhOc9oPCI9mLz3COMa7fBGxLaJQ
 y9Lgexed
 OFidcHR10nJ56k5FmOsNffK+N3Cx0kRhmlCcHMfqYV8ss+AJ7vOmfMZTdaFXcWOZATLNgAlEnCVZPbMTJdlPRchJ/4GdAIykDQXflIA8c1FirqCHIZgqi7jYkoChJPBT9vK5gSUYjkzpmVvi9F9QJu/FclQ1IkXx7LQ1bMu6bO2uJjCVxYOcI3iN71LQeRUGUw2SQrq7ywsdmY4zcS2fLwdnTN2xTFSg5Tj8DIL1sGA3z9V61+Ceda8jOF5L6Rrj8hgCDCX+AjCY/w1IcV3IRaCVRvmR2EYl0zgA/J2IX04ET57ipC/9PDWG+XbMd52QUOT33WFjy85y7s9zTX9ecpoYGyQ6DptTNjFaSVbZGl9PSVq/3N4rmPBp1qsjyH7Oh6VupSo2cLiNlupE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/11 11:04), Baolin Wang wrote:
> I just provided some sample code. Please make sure your patch can be built
> before submitting a formal patch.

Oh... Sorry about that!  I forgot to squash the commits.

