Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4D4EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FF86B0005; Mon,  2 Mar 2026 14:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCD76B0088; Mon,  2 Mar 2026 14:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE826B0089; Mon,  2 Mar 2026 14:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACAA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:43:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1E208AF01
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:43:18 +0000 (UTC)
X-FDA: 84502146876.27.7C69818
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id B92AB1C000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:43:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KEaZ6d9E;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPNnWZeU91X74vtWviIJ0traba9XBufSLH0afVq6V/0=;
	b=COKsmfTklI558jCykA7uKIq8I5mA59eHlsNpdALS+5fec0NA7DVlyRPUEVpNxqN8myWgTw
	1bK2eNTfnvVaW8U7BGDGJs1fYBxW1Jw2iKC7vLIUC5kC8FjzcSps+t1vzsj9E8w3MryRmh
	N5Th80u0f+pKcLbONM5BXnj/6DmmVfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480597; a=rsa-sha256;
	cv=none;
	b=GHzcAXV7ChaOnf4ncaK266bLNzvdOk+dsdzffN1XvkpxbwSvWI2s2/1jC4hA46lhKSZ+9q
	3HIyfS5dJaqVOE7c8K1jgwSmO9CFE5xiKCmODqyFya2QBfEOXdjEP/0Y28cioroFhqPOTO
	h5elXLpfzodt38oxRAqA8WQollA60Wg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KEaZ6d9E;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-899fa9610bbso21474246d6.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772480596; x=1773085396; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xPNnWZeU91X74vtWviIJ0traba9XBufSLH0afVq6V/0=;
        b=KEaZ6d9ESsowD3/nK3T3G9Buo91uCb0c61x/ZVVujxyVZ9tynJ/xIeUW1evTArsYz1
         Y0nWn7eR+Di0RXVfd0ak7uR/IpRrA+CPeXaz9lz3j0jQOM7hSeWKkgBnKvQfU5Em9j62
         d7n+fBVoqPWus/vRoEoPPm7bKyH6KhAyo81Ak01vVuSfsT84YXNqPCHqCm+qHYIOhFHs
         zFm5yVKjPph6QZuX3uH2jy4I5pF+S7MMifmXeBPHo/d2xPbhlj61k0/nQcjdVhc1tu4z
         FNtEm3FN9TElO+U1HwKwbpUIaBtiGhq52lTbS0200STIvHdfnJKtEisB94rXITL2OlCs
         jDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772480596; x=1773085396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPNnWZeU91X74vtWviIJ0traba9XBufSLH0afVq6V/0=;
        b=UAyOsEU+8yePGct12tilH+MTgbPDS7Evm9LGIRadTb6TigbHOHlJxrFXT71jog0EHs
         X4mXbL/DF86LXTdQOccqDs3OJDW9Wk+MRuhaLg4+Fl+5GNVnQUXiNgo/k7WNJ6Czvu68
         ly3xhtVK2Jutqijx3QjtufcmtH43tSdLHs4P6COZdFseIJh6LMtGXF55CWA+L/IBipT8
         7lRXWn37YQxmRmgW2iBB/kS+LFZ1WtKQfmwMe7ZlOKNyS6QwuXN7mttlZHlEpX0CXcGI
         Dp+xg4heBu23GWfI6RsZazgMte4NjzI73FKasjQX4DgqDcIfrlYAuuMz/sMHwLnk6LxB
         e18Q==
X-Forwarded-Encrypted: i=1; AJvYcCWoP3rrogrlr+PEVUPN6VdDMSJwPKZJIW38AabVWoaM5xni1tE076pTj3b2GX0JQAKGdW10MgxAuw==@kvack.org
X-Gm-Message-State: AOJu0Yywju6AYXXwPZ2KLYdb+wuZAJl1nFoxLWUw8F3AQ5EEM6Rhk7Jq
	Iua048hanipGTX7bVKvVcG9DlPCUdVoidqlU9aTRzLn6TX4X+LfVgSKmGZIyQwoajho=
X-Gm-Gg: ATEYQzzCfKK8/xsvwbb9GOOWrFrOJwTkqMdjm7gRWwlZHEVXz+UKAALFFrJLBqcDyP5
	bnAjqE8tmZjBWmC+0jAPTe2otAuQchXBh/72cB102j/huLb999SDpdIbyuO+GTQ5K7AJq9XbrmG
	XhsGLZ/h1mzK1p98o+eXZLZoJ5ENgFGRnRqNCGtY1O9NnqT5VKH9Pl5ghNpxWUIsnqUk1f17Yxz
	aBW9MqLrvOq2T9Wqsj2400r7QpR+6kuBoPX3Ak548aMqy0y/2W3X8M4wGr+9e1VW8J1wzmRj7cX
	JgcPcAIaekaY/JR6wh4FBNzgNq6cnOK04LEM4iWxmtP72dVNkMQVR0BvqDcXJb2nmYLb3dJiIWw
	5Jf9EvyfMjhngb6/9B+EC5Qp/z8UzIFlzpEk2QzeHNhUApgwotonfIQ5hiwVk1TvCl9K7cbWVhu
	ptDExKdnBy22HQGuNLCqdDTw==
X-Received: by 2002:ad4:5ce2:0:b0:89a:929:9e4e with SMTP id 6a1803df08f44-89a0929a5f6mr1131166d6.14.1772480595638;
        Mon, 02 Mar 2026 11:43:15 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a083a95fbsm3727846d6.38.2026.03.02.11.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:43:14 -0800 (PST)
Date: Mon, 2 Mar 2026 14:43:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	inwardvessel@gmail.com
Subject: Re: [PATCH v4 1/1] mm: optimize stat output for 11% sys time reduce
Message-ID: <aaXoT17JoTv87l40@cmpxchg.org>
References: <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260123150108.43443-1-wujianyue000@gmail.com>
 <20260123150108.43443-2-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123150108.43443-2-wujianyue000@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B92AB1C000E
X-Stat-Signature: 9h6ztmfzjwsbkaeogxpy1f7fqe7h85sg
X-Rspam-User: 
X-HE-Tag: 1772480596-459159
X-HE-Meta: U2FsdGVkX18aWsn1r+ddFKuMvkFzjTv9co0WZNi5xbQek44CGFI6gto7Um7ShnifNuRUIlgBDNN1XrBkzuFW4+ImLRUNeGd4zPvWy4P8177QGKGi6y7uFAZTbGyeSeYqTC6AuurXSBDWjZw3i82vLdlcODBDazZ/g1HP0vYv4UiwUn7Mp7AKnuLd1L+pKnMPmwYvUa8F/NoxgTuxMl2PuLt+5tSaIHpBr0iMsNnjArcQvXBKDTaXEYiTjwYtiZwA0ldpgq97I/8uPVGJ5E5QNlwG6bjKqr9YzN8N2tdUFJO6FdjS0sd6WR+XI19yMbd5n0FHgvuLGo9XTWLKEajfF8UVlg0oR2Csef/VJ97dfjOdgQKIh1Q/jLnHMLSu72A1P3hcQsVhLDTYdIOsDZO9wI0sj76dzIuWKH80E/E1/EPyfZGC2P6T32NYoLy0tKYV4bctf9ZdeM7SuL/VdPDzbwmHg7G1h0SVOeChqEgGBI442v66pXWE/Wn24qmbikrvuglAcng4pWg9T71CzDQfbJwK2xHk5kStc7pV+Z255gpaOGl7O+QjI2kP+8zbQNgYpEohT2oFcvKVJTBF/e0EVggccLrcKtsLgIdzTjAkW7FyN3Ar+67qVZedFqtMDeZbGx4F1JUe/cB4AOWDkaaAvNEfCiqyoL1szckS3DHCvN2v5LMlA0wYLLXPh4RYm4/s1BgrdTAbExwvYjwoDYwynW+lL6vpaQ5fuBgzySrv+V60CzuJW96htxw+Mguf7Td+uMj2ok0JvK4TrwSBp7hOEwrSj5vRT9fqtJaCfvoxsX+ojhnwIURjz0sWlan3sk8YRPCR9dku7EeDLI80K6uv5B1yfYu1cVW8JK3PtVoXiriKBlOO9MDFyZu+h7dCfC5CC4aKrDLvt5rsj6tkuFpJh3iwSHcHSrNlaIJi3XUh9BFTz+t89OTs5/uiJlfVfhQgQYRGnKNcJX0tBd6Z8Fv
 /mJdMmdh
 KOwx4ysEO843TtCqNdvccLmUifnyS38O5eSmS5aFR7gW6xo4Rf3EFF6UD0zkLFn2mXy1DI7jzOWGjPAENrrhd6oIXdKbYoNMxofmvOPV7Lhni9l+VGhyvRf5LKxRrAS34euxlDfTOZl9QZc3X5VQbqJmwdiObsfNeH1hndyYX2VPFVHCrHnGn7EZibj1RLQd219lkucmEf/NLdvrL114Lu/jpWCeY08jCtpmcPk8X5endgIUVIx9iCO4/AC8K6Z3Io1JqeLB0RQq3i4O/kGszzrfpZKofRP8ABrrhotff5vJSUnDtZPJ0WtihQrBWrw8Vi5kd/m+pGgyNbwu1WZs1bTJ9Zuokv17HZaGaD87uwkMOMkPPKbriTMZxLfmUaWsbkOqiO4eFvUCM6kUoczSqfY1K7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:01:08PM +0800, Jianyue Wu wrote:
> +void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
> +			      const char *name, char sep, u64 val)
> +{
> +	char num_buf[MEMCG_DEC_U64_MAX_LEN + 2];  /* +2 for separator and newline */
> +	int num_len;
> +
> +	/* Embed separator at the beginning */
> +	num_buf[0] = sep;
> +
> +	/* Convert number starting at offset 1 */
> +	num_len = num_to_str(num_buf + 1, sizeof(num_buf) - 2, val, 0);
> +	if (num_len <= 0)
> +		return;
> +
> +	/* Embed newline at the end */
> +	num_buf[num_len + 1] = '\n';
> +
> +	if (prefix && *prefix && seq_buf_puts(s, prefix))
> +		return;
> +	if (seq_buf_puts(s, name))
> +		return;
> +	/* Output separator, value, and newline in one call */
> +	seq_buf_putmem(s, num_buf, num_len + 2);

You seem to be losing the \0 somewhere. I'm getting garbage at the end
of memory.stat on mm-new:

  [...]
  thp_swpout_fallback 1212
  hp_swpout_fallback 1212
  hp_swpout_fallback 1054
  907
  1278

Dropping this patch fixes the issue.

