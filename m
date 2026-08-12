Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E963AC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFC56B015B; Wed, 12 Aug 2026 09:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80F96B0163; Wed, 12 Aug 2026 09:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE0C6B0166; Wed, 12 Aug 2026 09:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A10A6B015B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:42:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FBBF403EF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:42:44 +0000 (UTC)
X-FDA: 85092732648.23.C4F3EF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 77314A000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:42:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWKzH0r+;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ir7XnZTfnKiE1NV6eZ+BZ1phE3SdBSyJA2vS3hmoEBE=;
	b=OH9y8B0UKBEi/Jishg2bKMGVQEN2jEZxWgvVV9MAIz0Zv7PKGJ7BfABKQbSuvbYuH9brVX
	VbIkDkdAxHucRQdzPjJEnkOJjN5E5BQo76glM3uTU39YCUMJYSAeGSwrnYyFIRBmrCpjYc
	69ymGgAVb0TOg86EWI2QtqDCM2F6fBo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWKzH0r+;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542162;
	b=jYwfs/ILP/pq31iXHy7H9njgT9ypg0q54FVdMwnByg2IIOkt3tRQQj8vUnhGfGvaS6RZsX
	HYC/1Zu6slZYeOZ6/4LIhtVxENdIH4xnszv6ZSuuANNxFtCf6HGkjk0G0zJCb0VqnV/Fdl
	VFQ7gtGUaXXPIUgRcUqUaGPptJlGIQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3CBA60A85;
	Wed, 12 Aug 2026 13:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538911F000E9;
	Wed, 12 Aug 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542161;
	bh=Ir7XnZTfnKiE1NV6eZ+BZ1phE3SdBSyJA2vS3hmoEBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CWKzH0r+k35uq/gBzVBizUYYZ2YhQI2uDduyLZc+iUOmijU4V9LzofSbavHnWDumE
	 2zrnoXlZquLrxgtfJeUKT2QSxYTD3krlTBcv5z7PZLVmb8pW66nSaNyiw115Xp966F
	 NR/DWTYd+BP0Sx+MDHHthdceL3kWv8zhCWjD7+N0CBCmeBGEMDS38bEDiQu1JxQKtr
	 IvsCSrgMzGSzTsghoh56hHQzzlULSODd6GvbtFdXNp4tL0C7xIcc9FGVj8zGJu34in
	 NJuLdbxDYtrHj+s8hRvHE4lfySVAalgKQmz7wSUrDAjxLsMV5RxCC78Y4W1scuTreX
	 qZsvJO1cKiSgw==
Date: Wed, 12 Aug 2026 16:42:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, shuah@kernel.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	peterx@redhat.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Message-ID: <anx4SbvfHXOHVflm@kernel.org>
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-2-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812120821.523860-2-husong@kylinos.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77314A000D
X-Stat-Signature: g4ooauh3dfbkht1bqxm3iru8xy4sizj4
X-Rspam-User: 
X-HE-Tag: 1786542162-24980
X-HE-Meta: U2FsdGVkX18a1YaTgW5D8J3jIA9ZLh1il2IYmZWBcy8ciF0dccmuVdY57hF5sRs6zjTUwpfp751mIoTZNPCS0zPWg+bNNyNnPLKGBJGodTw+TA91b2IRZpdg35stIGAzp8pWlZ9n/NotPa/K59m7NAWJtvXL54s2xEQFgrzR8Ev89ORmnxhVPROeXgkzo/siOAwxPTe+Ee8NBKs9l/oa/AA7/iyEFMW7V3LILARfCLIL40WYqG80czrJBOTMBMmdFME7JTUUFbVUKlYm0oPsPxDDcLDb3Dt07UOptDI7yhlNyVCuDGpm3dzDi6CDctBvZry8ou3aTcT4hETpdHY3u8N5V9qhHpIcI6YXG1h+U4MdOWgw3Y5y1RItPc7/iM3pMwgLW5LkZXNaBVzgqTUkltEvEiUD6Caf9Aa8wdSoj/cUbERVxPTxDlYp30eBLgJPZhAu1IQbQ4ieXyDGhzVuXpDew6E0y/ZKD+Kr/M8iwlCgH/5IYyLChuUekC3UJMUrQyA49Gd3GTc07fxPZBVYYerstO7tT+iq7heIaquPHlhbJ+Kw+R4km8+fkuAaEwhLACXn8kzrOBlM3TwxhKn/rnPirGzvDg5Yi0fwqldFdG+8SF7y+0ao08eTblBoDxuwoa26bV46m4G756ZWfE/TDl1d2sWH+AryEQFTN/22H31zDRXmUrAqV7EJtqrVO7wbHF4waoQrctx975pjojauPMVvn4wcK4GEweEmDdzD3niVEY5c5GcPxAyqf7R5XsfZJgw+DwSkjj268thI+nAHuF3r4dM53TWOcWsLdTs2BumuoG75AWyNmIw5/NvBEjhTzhiMZu+W3CQB62m+lv73nHH5muc/v7t8U/X+9Yb28hbvv1WAeeCQB19Cr5caLjnQUR8+oU0n/R5SItbPpD4N9wDGMVStiOzEUUqbOkyTcpx+6lONY0GcbWt7rtw/aDl/TQe8d5u92bjQFXczSdb
 AM9OtKpF
 VpzTR+uNY63xSYDUORp/mYi2e0wR0FjdptiuoT9pscc/81/6znKsr3vvb+mzGAylOWPrE0/yVi3MQ5OoRdL0nOYGAOZyILlANcuXZiXHF7tBq29FHIoVl3/Frps8U8l86+oLlWXH3iBdBMSkM0c8cf/fOYdCcPTO5CyI8Yk3mB0ZoOJe+TpDcBF44fZiVSWJQ1vw7JLaKoAla0hFicQW1ATwtUOfxSQWSeISjAkWgK+mcxxn70ve49tMjByNC2rql6M35ru6rVtUs9B51aCGP46Jfig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:08:19PM +0800, Song Hu wrote:
> uffd-wp-mremap calls ksft_set_plan() with no preceding ksft_print_header(),
> so the "TAP version 13" line is never emitted and the output is not valid
> KTAP.  The sibling uffd tests (uffd-stress, uffd-unit-tests) print the
> header first; do the same.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 2 ++
>  1 file changed, 2 insertions(+)

-- 
Sincerely yours,
Mike.

