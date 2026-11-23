Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0961F606A691
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pUDmEi1V
Received: by kanga.kvack.org (Postfix)
	id F140C6B05C0; Mon, 23 Nov 2026 12:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4AB6B05C1; Mon, 23 Nov 2026 12:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA7D6B05C2; Mon, 23 Nov 2026 12:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B496F6B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41F11A07E2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:59 +0000 (UTC)
X-FDA: 85467089358.11.769FDCD
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5536D2000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pUDmEi1V;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455417;
	b=OywFdky+vrBNRb9gcVbzCZqSKv1J68GhQ7BPe84BovStu78BgAUu/u/9F/KMy+Bfdcph1h
	DScMUQ6WxMTq6J7IpxASYzw6qGR5ZDhSNJ2DhGOvseSi87WINN44yc/js3YMJmHoOGKM1S
	1231zuSjwcb7L+Eyw5AqhAzgl5epjdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgTsp/DxzVnpN2p0duzzJ5EXBBoNw1MgnrXgm0rl4OM=;
	b=ZLRn3O01qOXhK2tfJDFkbCdXfTggOrjxDQa8S21T7ZDrHoEzEFmBcgcCnlYqzSAfd7e2Vu
	OEKDRy8L2JDKSkKq5RpTDZIS76TMWdeeqkaGf6LjM0MO9jMy51ELqoFH2gLS2PH/VUWQ9+
	zJvUiZw5q2GeigPKLSiZFvYasXGK5b4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pUDmEi1V;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-3831d564bcfso1418875eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455416; x=1796060216; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bgTsp/DxzVnpN2p0duzzJ5EXBBoNw1MgnrXgm0rl4OM=;
        b=pUDmEi1VwJmZAPCQhtw9p921/M7KeeRxrs2gwFu487H+acFTvRfOIEshkL0ohsy0MT
         kTuHL/UKtDuvsspK4xMY0uyzMbwtle2KjKkjjCjaI/9RclwH/NW2hb6ejb8PsmKrF0MD
         p9EFl0yFb7lrlVJ2uZ/SsYD273q2PeBV8BuHerHBx9mQRwdiPI37QEDuxMYuG87EjEBZ
         +H+HGNvunlgqR39HRcbXTDsJKIk1kqy3JPG0d27kqcF2E06ka9QlWpNEd6nCSGUPrLKo
         ZEddmsYdI7lkoG9zk8/qbXS7ZAMlI9SxGODtJvHt3E1icxNclLjxVS67GzPU2q/TJpGk
         J7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455416; x=1796060216;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bgTsp/DxzVnpN2p0duzzJ5EXBBoNw1MgnrXgm0rl4OM=;
        b=Zu8UMPqRft504j17KnlitNBF4RnNcHFiR6C1JvKVw86rbWei0knphbFSexGzubw374
         JBvXMFLl3ZTi8Eq229UdSvaeWve0GW0HjrVd2usnmTtmRX+XgahYjYfbuqx5BpzHmBoa
         rfrZF3VXaeo5MqWAQNVdELBh3EvM/MY9W1feNx22AuidKrB8xhQIsxj7O3XMrp7LKqdu
         g+5d347qA2f4iIWj7fiGNwHUDtxRNWhiqGKzhOX0XWTvSI9EzhlJq+6qXrzbkn2J8B2F
         Mh1z2QA33OS5mGPpgxMWcUKUfYGPmmnRwDFsaYc8dT4tgGawL7zPhm3bfAhZuyQ4dW0S
         HGzA==
X-Forwarded-Encrypted: i=1; AL+hErHP7AxWvXE/y9JBXR3jDLU5OgXn5UyGmohnu0XP5ZnR+VIEU88kErWlylfDcBTiCG36SY8axSkBYA==@kvack.org
X-Gm-Message-State: APuU4Z8Ilt4zNCgxyfg09qOp55He30FCog7TKiMnpi9OFTP2z2KofPvO
	svwK2Em78xtbGDNMPGWYSZHqJhC7ANk5dk2IWH/9dqPfz0ih3ZGoytxN
X-Gm-Gg: AZFdTZe47ydpvFQgovEQ5WZEPtyhSfaMZKymmLvtiwTRrZUK9+5N/6o67OVbaMAJOdb
	0n2u7gThsZwathrTDW4sYQRrpF/T5oP5SGlVQ1455ycNySnHUAjhj1OnadkYPE7ubDku0GnT8KY
	hObjaygZfWVqMOyQhRgD5rg2ok0jSUbibXhn9Xad9aQqR2+7W5vsfdd1ritY/sOO8ieurEf57tz
	baGajd/X8liZJ9PnzbOwNXDD4W2j81+OgVkn5/N7OAUQ8TfQReJXxcQoP6wYHQyFpK1qKWNbob+
	rOJxWlEansPUrWsFO/xRu0iXFOyNY8A6eOj+XDqtR6gqufhaO/xz18RK4ofxCaz/x8NjsfQItaN
	hTFkCtgYsGdPl9DDlwSPgpkuNyrNV0JwKjZSgBnW0/+UdQCzGe5En/ZF50DwpFCgXYa3w+N4l/I
	Zmyd9/Xsu1AK/8Z6MyterCFkkUyOTYGECyLfBlQ0hVYVh1X/IrLbEGLYPtAbS/RSOTucFsoYAu0
	f7OWdBppEqmzKy7u/bKkdwFKuWL7q59Jg1sBu2vFsxU+xVN/BtL2pc1+OKsuTJh3lkV0tQrNmnN
	JU7GohTSNGUL1XEAteFtI0KrQXmHmCtfh5OiF3fiUK94PwK37edu+5ZYf17F3pxn2361dkS5KTK
	7ncEqS30Y+Q7cDCgirUhPIaJ9YEpkR9DUgY2VaElufKBYOzSxKh61kOy3qEBIgQ==
X-Received: by 2002:a05:693c:42d9:b0:386:bc40:1508 with SMTP id 5a478bee46e88-386bc40185bmr746802eec.14.1795455416017;
        Mon, 23 Nov 2026 09:36:56 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/27] mm/damon/core: introduce
 DAMON_FILTER_TYPE_REPORT_MADE
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256509.4.9812891949286022161.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-13-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-13-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5536D2000C
X-Stat-Signature: c16fnzaognkz3ody9agtfo5enoayqb71
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455417-61719
X-HE-Meta: U2FsdGVkX19A1G+si2v+5ERVUYSQ1FvLb7npLXvvycuitx85s6SylI+KazoYMghiXklgpfUZVhJrFeq3/V8PQGRlANyIjhbFn4XADfAGXDQS6C5nli4go9s7zdOuoC3b2vp631PL7/jrNj2d3VjlM+TMGPbM4Ml9VDcTPREuAa13V2qSSPDG4pRD3VytdxJp+Jz1jjl1c8MhlcDcpAbhej/Y9qEJRhC/xfIT7vG1J8Aczu3tjrhA2lHZIeWL0ucHn6U0groQhcDQ+0jCffopl/DlvtG9Dts6QT7hX2Vhla5mBdClirmt+KGAJluW5obEMtNvPxgkvJV5APWlxyqna2chMI3105dRQcH84KnJDv/E6w7V8DkynDbZ0vxB17/t9AVPWx505obZMkfS7bpJ6rM/j83TFeY+hWHXwVdDtcjxPr2/z8NTMr31hLQLnjChLv0PjKHq5hU+bZTZnuzk0jCzG4Cq+Qj4FtbojPi9n68OK1/wY2BOqbnxGe4J9HKk2s6dTBbEVZSWTaFLRG96G3Ard4umet2o+5Am/go+VI3wk7omEl3thbATiCU/ehXYpKQ9JUGErUAnYiOx3cVbjziYRgMtS+ejTnQdccjQFl+eEunNKaEQlxwiI4RzZW+FmPEvqk9oo1YsCic1pso669b9sEXFJI3/9oCiNcOjPkhi+G38myFyWeMOh2Azt9lsByJiJEeG3z8Kb8cvbdh6AH/7VEH9qY6B7LNs86BlcwGQswNJh12IIDlT3TivhqUfcQ/tqzKKtiWv8mZXhRn3OCMg3s6omCj4QNqkYLvs+phvTfjkrcjiubsi91yMXto7jLBkf8xzpkfnbkPUBjNlaB38UGKvxo4NDKqWyF2kw5eCKZFl/0YtkG892o8hGQEbe/lWVTZTGPF3e99h3dztEWvWIqanS1CT76JpnLDvjH2sWWbV+mDgOkP/4Spm/tAk2sR6xolRBFekDWqOtKU
 Ry3RfEmV
 h4o86iHihbJSSQUkPvYJRit2xDPusmPFkg+qJNqSpn183BDG0iV0+sxcio7SdbDTDeJRIkKoUo+7aw6FRM4NUNVgv9HUdfQ9Y42J6n0BbDmv5DTlaIMEJVVbPBuwqvtnyu96r3b9hkVHfs5iN5NdKPBkFkX7gAgbedF9H77rGBKT7eMP72NRBZg+ouwfFRQxNaBgrMT5ds8jqgWPLcCYGtlC3fNix4KEY6brP1TsXGy2nl8RwYtToQaouakv1DvjtPRGWmLjBl4OTXDgrz2d71bLdgx0DGM9FNnpPgYNjPUq0+YN1948yo+svno6Wg9w6hTM8T6MXxWcQ6CkNI3TbNCP4wvgJNwsmhRx7vl90GnHlqycc5cuLVCACaeeNnJR9EwQRlTPMoZnwSYTXBaxV8b1mxfp03TknAXTluMGz3z0XsIa4Olw45CBjIEgApsVg+gPioT990Ez65bI/E6zZ6PpCTDjfjAysoXE+0xZzavKM18H1LcqiJDiyETOZ1tHq5TgPe+NG5Kynfiis0iAHzuJ5DPPAwWoi4YB7BtCRkp4SoMPKld7KhVW0sXAvuZ1F12lLBGkCP6ZhUU8Xdn8HlO5T/p820HiUjXyOw5EH75W8i2gqVh3bjKXx5FeR2WtsC+YPT061ai3uriSu2Om73otWgtaN64fFncOh3cQsxN/GhvtI9STRmP9y8v3Mkaw4KQFjV0thqYrJSVuwyYLKUj7TtT93dHV13EBTZkU7nXvjpxcrnJGn3wbZgAK9xXg1GgLRy6Q18WAJQdHNc9LFC0QbffKY190DYDNeWTWtoDxaafk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:56 -0800 SJ Park wrote:

> Extend DAMON probe filter for the existence of data attribute reports
> for the probing memory.  Define a new filter type, REPORT_MADE, for the
> purpose.  Add a union argument for specifying the type of the reports
> for the filter.  Update the new argument for the new type when new
> filter parameters of the type are committed.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

