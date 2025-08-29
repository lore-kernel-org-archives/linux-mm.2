Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA94CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC048E0005; Fri, 29 Aug 2025 19:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CA18E0001; Fri, 29 Aug 2025 19:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B908E0005; Fri, 29 Aug 2025 19:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50CC8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:11:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 716A5C0A47
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:11:24 +0000 (UTC)
X-FDA: 83831343288.15.A192D73
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8ECA2140005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:11:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J7m5K+o6;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756509082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqQqLaFsps1wVaocAvoqbMPJ7LhYdPmq7DHWmVRwav8=;
	b=chB4b64zkyMspIIjtL1ySzF+5V2hWLIdYFkJuoEB4tePOn9QEzBoMP87U9tfE3+/dzwY0M
	wqJN94x1IK6cGalgg+PO+bo6QJLiU4plJJPKjaxXfI9hB/2S8KXnFJ0zkPnSdxCNs8U2m/
	ba4Ho0v8Zu4iL2HX2/9pqCR5qycTYB4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J7m5K+o6;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756509082; a=rsa-sha256;
	cv=none;
	b=18Qj9a9gkem9EeSkbo4ntcSuG+mf0iY1K+fPa/mIzOrF8e05saLRC4+kK1xZ9bh0OQlqKr
	7TUANvv0ul1Mcv/7aUR1HhXXU+lgDpr4HO8b6jjQWC6LUVohHjhsOA6tbB5TqqTQh66nn9
	b4ue8KUkyTuHJB0CPietjGN80UIxQdg=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24622df0d95so20794325ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756509081; x=1757113881; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bqQqLaFsps1wVaocAvoqbMPJ7LhYdPmq7DHWmVRwav8=;
        b=J7m5K+o6fkPPALrr/5eZgFJKOUU8IgspzRDjwGXjXvAyzzCL6u1YwRVAn1M19abei3
         NbwY/0Z+3Cn2g1BKXilDyvG+vKG3FYpoS+p7DWdozuDiWsBwQAMzjQEg2NspEuPqdgNz
         I96ECxoKMD3wF2DxSS+GTDR3CyDA5BJSOFFOo2PFAZdzempNCrQvvGlQ+iBhqF7ra1rI
         zFuqOpOolPTntpt0bK5IVuvt9RIVdzS48Q/DUnJs7Ztx2mD2iwb5yLUnXMCUQ0xwpCY2
         ZDZ9XshQ4jK920u5rpm/MhU6fEOGCfJwnJdNpWYDurE0oyVxjGZIupLwXydnqOwKRNr9
         Chxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756509081; x=1757113881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqQqLaFsps1wVaocAvoqbMPJ7LhYdPmq7DHWmVRwav8=;
        b=pCTSNX9KByRtCO2rA9pE9pmcYmZNR6kjiYwVTz5RBlMPiXfsANG3CYdLU+ycPIwXSb
         1gse7RTi3B18fka6MGVzWDJdEQCfpINyk+jaM4cLTOCxTOLVBqp4IRLwopNmSTnl2b1b
         pHJAWoBL97tSTGNbHVrhMH8g4oP6HZ3XZSapoVLVgPcb9Z+0Pui5UDrjt8YkN6ypr7Zt
         trU4hnlZy6d0Nv3vgTAJLQKN2W8bQKO+S6oU9EMhxWY0uiZHJafVqw7WNIc9KjJLTvyP
         mWzn0ReJCxFmQ6F8L//5sNLG4g5M+ZfUUm52tx4x2Q9CvcahLrjVvfQUBIlcGaMsgnNQ
         JhWw==
X-Forwarded-Encrypted: i=1; AJvYcCWP9AAs3L57+GjHnGw1Ih3Ud/LflQMj4VjdsuZNBCCKcYBcnwRZiioC9zDDaXPbYuGfhpjupXveDA==@kvack.org
X-Gm-Message-State: AOJu0Yzo51qQ2jTrueqoMAYouvlZ9a7LabH1RuKx2D4BcH8nhxRNt1So
	c9V0UhoN+VkWvHCiyubQqJhnf1zJ2duj0FxFO2oXCUWWCBxTeCIzwRTB
X-Gm-Gg: ASbGnctL2JrzWgNXHjoXTrYBj+qnvKuSqs/bW0hIIRU1GQkoTKUGMBBEot9v7c1npvk
	WHbfM/ASTY4gEQ4Nkb0S9pF6mXVIuMHF1eqoRAYxtZPFUNyuUpt8kycJoA/MVLt2mFEDPdpQDrm
	k4HoKM6+7vSTmy3KbCf8LwggVFKdvQF2TlR7bWHD6A17HEFG15OkdVVPEvfJZdKWpM4m9jfLAp/
	rHAzoY5uJNKUlrL/Q2TVT5iw8+udWRZgoM7dzlWTdNd+IncEONxDK5xEZZoxK/zDmlRovzSAIF7
	U65JOU5oDULyhBukO3StWntCuPpFpmI+7Ewc42CbsUclPw+JoD7nprI7PZ3Uy1vkjvHhcR3DlAH
	+kTgRmMjud566j9BH83HHe8LZMu4A1GyafZQ1zqxW1afhCOp+YpHhykiH2TuBPccb
X-Google-Smtp-Source: AGHT+IF709aZ3IbIL2k4n/R5rHQNX2g9ksg2sYhPpZgYz9Wa4/J4YZRAVYsKytfiMLpEGoPVPVyovA==
X-Received: by 2002:a17:903:284:b0:249:40cb:a704 with SMTP id d9443c01a7336-249448e3de4mr3030985ad.15.1756509081452;
        Fri, 29 Aug 2025 16:11:21 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490373eb17sm35355625ad.54.2025.08.29.16.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:11:21 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:11:18 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 04/12] include/fs.h: add `const` to several pointer
 parameters
Message-ID: <aLIzlpOQ2uMVDpjQ@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-5-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-5-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 8ECA2140005
X-Rspam-User: 
X-Stat-Signature: tzyzd8sbuxijshbehkmgjkm93ggi4di9
X-Rspamd-Server: rspam09
X-HE-Tag: 1756509082-445250
X-HE-Meta: U2FsdGVkX1+9WIeMMPyqSsjE1k1xHG/0v/GqeWaWNTLpVyNIB98CR/io8jkT5YSuv5ze3n6nBStURExabeDA3l8Yma4waIwUs3p2TBU4Ff34+loCX+O9ZAc4+iTTk5FsAyxppwG0BaD5+hFcYrO8+dMD8QQyaeyoRqc2B/MKy0O+9kmebqi0GLXsXxcaf4r1Njl19E0A3aFOxxd/AbCCf//haJ2HWyK269MpbG1YX5PyPCC2p2JThWNuLaS3smf4qL9BQKPGLosr21XBucRSrj8+9w2ZG2l30bFTihqS4iscs2pLPy0MzxQWQpURWjEG3AsQZ7mHjCoIzmeFKfes6NwdkCLT4kHmzCtA6+0P7KMKAX5Lbc53a1uVnHN/5F624/a0N9iu/yY5JwZfw+F+pZTEohCqDDMKuEuGw11fCAoF+QidWk6pAgRHna7qcXIOClNGF9eVzoBI6pQI5eqUX3taC3xb+hiGxHiGPRaceJ3D0XJ32zEhL6opM5SsOJ+FOyu0gZFrf+Z1torzkdOvBiVYTnNmpV3DI1pRuGKbdmBNiCI4idPdXsYLbFG/dUgkSEh3iQDD3hMkBvxr1jiCbL8VspXSQFNhyluMV7aeNkBipJOVpB5g2QSxHxse4kaN0+DoBWJg7nPjGS016TiC8Zo0ZKW74+VrCdd/XOzN4Q9+610pSwIplrYvuvih3jieUBSIAtO8Fzuq5JVsGYWXejQ4QpXvFvjbG23uh7t1ykdvoUDNNl8AKicisW1CiSk6TOvMCxBFlnkb4lMxBARcfv8Y+itYZAbzBKQUtR5RhoGk/Aw5JUiCc2w8zqQEg1u2QCWkBL7wtGKUTh+W8FgRkTsyM24NS9v23QPgxOFP5yJptUAsqKeecpSkvzaCqy+cEslxM25QiuQs9AHZ6SeLfZndehOtDZTkRjWICQjpFZr8xcAd94zFSVMIRQizM2IWNtiM/NaV2Dmxx+f0DHR
 vzE/qHZy
 6ZpILDGlp2ealtELjn2EoK38tKLxFrip6MJ0WXuJh5Fvc58KDAsWr54t8W0UH1I9V1GI7vltHjIKBHnmfH+Lo2b3Fw6tzXZk7njg7GE+z4pzW2l0M+1sKQ9Ztv3YPWOO5enVFXA9hPFRAfnoNwVyFbezIenLMmrLt+piS0rls15kaOgbSh+l+w6NGGNOoG028MAf41B55qd9WKXvZwjzQPss9qBVtGPkCregp/syxlnp7kihqftWS6BODlNylShGMTEhHWZCTUxP3z3eitYLGbtBNfKO9WG39AjDhGygI0kT+hfULLYVr7Fd2e6J325YXZTSRlszapM6WYkzDTRkz31cBdl9M9ajth8zeNbfnVOKvBkwb263N0ZTifLauTc2xInTJhfI3kcpVmLLrOV2VnIibk1SDviS9RaqOsQ2QxGQXUSvHhMiy6J9CqWIcvWtUWN55t7FAow6NctRIrN0UcWTKa7SShsORR43OxEdJZcHdjqJUBV81iDmiDMucTdcSZNZS0sIG1iE6EuPxwBU1o7Fm6m/yy/fjxTdtOClX6kwqrEOtp2eIKXWNorwfgnx7dtrE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:51PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

