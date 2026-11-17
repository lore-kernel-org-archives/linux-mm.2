Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35243606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vzjwi1/i
Received: by kanga.kvack.org (Postfix)
	id 5824A6B05C4; Tue, 17 Nov 2026 05:07:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A8F6B05C5; Tue, 17 Nov 2026 05:07:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496C56B05C6; Tue, 17 Nov 2026 05:07:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B58D6B05C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:07:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B56EB40376
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:07:26 +0000 (UTC)
X-FDA: 85444183692.23.939F035
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C526F14000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:07:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vzjwi1/i";
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910044;
	b=W9kFjL1to2baAmDL76JjAsDASN1MSkFk7bYq3vtV0GPLB8qd4/Xz9MvVfVwPPq/WI1g9fM
	IRK1k/k6PI1k0MZ5rRf1INxAfPgYR+YnV5ERZfPJelGcoSnr4xP89WJj/foURsWFR64yRQ
	um6dd6BFs0QewPSsViUAXsn6JoaWOMs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vzjwi1/i";
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fB0tSjEpeVMnmpusdLO+EDcnV7mxDkwNNJyyPw8a5DQ=;
	b=wjs8mV48ZXqDpX2DU0ZSlvLrw5loNZQr4VaniuqgEL0GDLqtWyg1AE+UWemuXtj9FJl+ip
	LQf6MGlCzza2C9gZTXIGWVnIOLowon8DzhwRzTyqhUL8HCNNyqstJ4wzslAckWvbXDUXr4
	TCzxZS2EuBgLKtjZMkMDdNAKRtIyP5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 070A346812
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7A81F000D3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910043;
	bh=fB0tSjEpeVMnmpusdLO+EDcnV7mxDkwNNJyyPw8a5DQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Vzjwi1/ihkFoAigcsjfkg2CEQKs6biH845zIgKbTVRYy/vpbKFYOd+IMJB0bjGrh/
	 cOMnQmtelQkgqHo/DENNb58dx7XBh/Oubb7ybwMSdt40wb2vddliaNfKbyK0pDodvw
	 EcjfUpzIniqcvS533gHXt4a+1WFCFGVA8oDthHqVEf3dqfWZgB+ndHA/M1oIZvTf1a
	 6YCLdnT8+8OVZAgf5+grif7m7wwihvJUfA55tKiV0HMLRn0RxrCrSi9L37af4zAEzv
	 rbvUAtztKu7fl+4J+lYQa+d+3GaMV3StUHgnnVHLnjlPJXCByeO/isF7QbZMpqWPYE
	 XiPOVv12pbKNg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-94961ed97bcso397126685a.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFrXoWTYr8vIMNjH5yAaBMYlg67AK9X4Mabu0gJFakbUrud042seiYgru3ZzSlxWqsXJ+d1QO0yZA==@kvack.org
X-Gm-Message-State: APuU4Z9kImo7LpyU7u/vFqBRqhKpbFntP50AoT4iwwF7S4YUUO8iN24i
	QLdDM1KTYDcI70IJKHUhm458shANCaEaoGKx7YqZAqwNZSrOl9ijlSWl1psPC1n7HyvwgtgPWjQ
	cd2XrU5ClKApCXsd2Srx/Iu6xRbseg6g=
X-Received: by 2002:a05:620a:414c:b0:947:84e7:f617 with SMTP id
 af79cd13be357-9494bbcc0f7mr2241604585a.64.1794910043206; Tue, 17 Nov 2026
 02:07:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-5-2f845e94dd50@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 18:07:12 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yxk9FpQMrU62bqVJP_yyffOE4QfCoH6-kWR2k7UDxw4w@mail.gmail.com>
X-Gm-Features: AclHuK9XqfHSSlV3-H8zXL-FPmnxM_EEINXhbrW6SExBJJw2kdb1xvGlKxX-YCA
Message-ID: <CAGsJ_4yxk9FpQMrU62bqVJP_yyffOE4QfCoH6-kWR2k7UDxw4w@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 5/5] mm: nommu: remove unused heap_stack_gap
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C526F14000B
X-Stat-Signature: pgmm8gedjawrqb9pkrqfxbmtohtq74e7
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794910044-483975
X-HE-Meta: U2FsdGVkX1/PGdZeMDK81tic5ivmbN0TYQ6B3ast7GSoOKZsyNiobI5Um3RtRiSSuJ4XdCfil7bG2wGkh0Zxs1Z2ymw5+GZkv0FKVss2R9xbjj56TPNmfO3nKEk9SOlRAsHTXVGBRPolCEb3/JrKmN34JIlpwl81hJN+MitH92fQQC5NacV4br8NTSrWx6BfxEJX/AMs905MYeMCqstfubobYIWiTK9eKOeZ3f4Sos3k6U5Yym/WPgs680QuzDCl/t5Do6IbLjO0XkEh9NC/0iBRTjHCShfgN2utffviQa+1dlD/KWZw5A+z061vrKuzArjIUS97EjWbS3jzPR9Clp+HpWljmEC6qxL1Mn9X9H5gvtfb3W3PFTZcdwYSqiIhPTp0+VpccXTtxbNnV/oGhGZWhVixLyEY42VIsy0ujoRiqfXzoSdEBG83xQvGrREGngZ1/7C9mWYC4fR0+AeMjphZ9UJ1s6mCYAf2qJY0MSKkG+ZacalUOWppz/2uioyHQ4Nuh6Jtlj32uV7fS0emtuE7moXeNFaYeDlRktmohi25RtpPBAmQzNCsn006fuUneQjPYlzcapmhV+kZjZIKKYJzYIcBWI1pEkoMPHDaUOdkmNElssRZBMqsRCqZrwgJJU18CLkS5Gm4TERAfnRk53KigefUdV7kpac84fyfNoLdw47wK5Lu/125PLctsAmXkogT5i6RKkLTuf/W4/gy57x+vAj+lN61mbhiGhe6mzU4IdMcnGkTgKShkEIljo0r/UdjwmFXKVMKBi5lMnQ29fNQfYThm5ASbL8/R7Ye619GL1gfPCJo5inaUINpQbiudrKZgh5whLZ/4PMfFEWnEQCWdDNwue00IQfU4gOJVZlH6R23ukt7WKWVkVtoKpDkP4Zl5+ATStXtCf8K1vcApFsOguzn1/WiP5YnUvhNOv7EOsfH/NXIEtYYYeM1PIu906WNcHEkpP3vVJEE1sn
 Ikk1ube+
 L96oa9QySVHChHXjhiWZEOcsQCrk+sTkbQkd/eOgUfusxUf+59d9w6BBSEO8DO/vZbjLvg4fM30no+lZTvFNhk0EriFORMzs9r2zuU0xYw8xjCMdFxyhVNFbj/IxKoID2gwX+e+dsENrDWKSOo1CnsHLtpaVxc1BguX2Gv+7QGBdVhdRTksT9YCBLqodIBB0/4GpX75jpY08+oL1NNKmLcsN2Vsmo5B6ijdZlQB0kbHp4HCa0H196zWIPomXfj6UCssdwMcbJBFFtTdJz17t5c8AELTVnZBBjmjZAU1xr0uJOCvikphOUqJrs9zgVrPpiRWQn3NgYxkPbQIEsNgRBs2iE6/Sce9nmgUTj1a1vmD9W4jMMxnOgd7J2UgOPVk+RTy2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 3:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wro=
te:
>
> heap_stack_gap has been unused since at least the start of git history,
> commit 1da177e4c3f4 ("Linux-2.6.12-rc2").
>
> Link: https://lore.kernel.org/linux-mm/20140430083620.GA4711@dhcp22.suse.=
cz/
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/nommu.c | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Barry Song <baohua@kernel.org>

