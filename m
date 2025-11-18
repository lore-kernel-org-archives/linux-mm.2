Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CE5CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9138E0013; Mon, 17 Nov 2025 22:19:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479688E0002; Mon, 17 Nov 2025 22:19:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6FF8E0013; Mon, 17 Nov 2025 22:19:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1388E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:19:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D729160371
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:19:09 +0000 (UTC)
X-FDA: 84122271618.02.24B2700
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2F7120002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:19:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=Bkl9jlVe;
	spf=pass (imf13.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763435947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jn2tYAr/EHfM0hmtO9W5VlUn1ZQ1mGdkQfHiF3xGSKY=;
	b=BF4f0BhfGZmxaWcmuCaKVKUifTd/J4EKtCE8mtsqjwOVGNOJP4KoVhHiYtCbNQA1GQoB+3
	99+PlIXO/W4wAOiscRftYKFnZiRXC8V9hX7w8wTWOEuMfQYbmC+JpfKgR86dUm9v7Hv3Xp
	kCq9wy6AseKk5vNoY7fFznMvjSBMsbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763435947; a=rsa-sha256;
	cv=none;
	b=qshcUq5Q5cj6ocXHI56DQNrlgnAhRMt2TQsZDoPtGt5TRCKqUIlwSEar1u3ou4hV+jjbrq
	bB68lG5nORAUDdfDZu6324MkaGjzt8FdoaO0yoq5ROMD3sV0PSceuu4HjCDFOLQJx+eUfe
	8EjrqPTgv5lwfk6jw0jOe4QYARAZytU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=Bkl9jlVe;
	spf=pass (imf13.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763435939;
	bh=jn2tYAr/EHfM0hmtO9W5VlUn1ZQ1mGdkQfHiF3xGSKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bkl9jlVeKdYI9eoOrlOfaZk9tih2w5sT2uJaAMYdTx3EAIbg5+oqVlcmUlQk6/f0r
	 egPBODPeWRG5TSO0dPQeN60IuTt/n55xJ2b05W6zBBQkF6nuPZBuSKkHmTVeUCO8zj
	 o2CrbRNu5rO0jSXGVlSzG3XcfT00LVK/0hIFh604=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 4B8BC81D; Tue, 18 Nov 2025 11:18:56 +0800
X-QQ-mid: xmsmtpt1763435936tgfvowgug
Message-ID: <tencent_295C252FFDABBAEBA3088D5B72DCDE15EB05@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4AgfdWAQf+qZ54lVhebfHhdDMGqPAgwFiuq0THzTSkCBhdmMX+SzQ
	 1SMlm3v0OKFNJFAywHUKrnww5srPjcJKEuNPl5ssQDpyPwRFYQFAyNWb+Hi2s8m8/upmOCtNGZWo
	 MYFdkvoPZll66ZQWSoxSdb1MKDUN1Qb7u5ekc6t0/bA/151Hzwn4FDtNAgHCTRqn7h17cTuNm6/d
	 aGQgL5VFUhc3+Nak/vIhzxIsrf6t7Ben2Bbzo3rqbjn6SC3/DyXyYgKLcsrb0iBmfa74TcMgQNUd
	 JDIdSJyymmnksCOl2o+PVXLzbQJFZFW0rjI9n0fmD8zmO/E5dUTveZNx7sFl2hvKPNx+3Fjkoxja
	 F7Oy5ud5aJpm/2ImpuNF9Ugl3MzRinRokeL3t7Ciw1Ie9Ki2QjilnsI82UOLogfxGQbSTKL1oDZR
	 aqy26wiEF0aJJiw92pCiysZs7lVadk7dxhZPk5uXmlLYegvO1R0Ku7yr0UtjWKDbTqG+5nQ+vDHE
	 Uo4bq3PepD28JYo0GimguFkNK6GqbZxZoGO9mNpmExkqm2xjjveRPjoVfrHmtMtnQv2KUxk3gACx
	 C/x1DQZP2PoJ+M5B/qmb5X+WPjJBdg6o5C5+RXR1jpViwwS30oRO46bNk2TbuedQ74XSAw96oQQB
	 w5jlrwlF8kziX3U3O6vd8RA/zqZoiToME5olPsKSlceYPpSvpE/QJZo+6B9MXgYKXFBroZ0CkWFs
	 3BTyKG2kCy0fAf2g69unnmGYoOrryIeWUZR7IHIqwKOLfK4+DdgOn01JpEb8H+FTU0UvURTp568+
	 KnUah8O+bw0dEvVczYY+oDlD067lJtAWTgfrnjNsQiIoIcNWh0M6S1US68rMv9l4YPzQMgRXEXBy
	 Uoa2krF+hrMVlLlCCDjjBKr5Y/tkUfhSx1wPDaQH52XUGqm+XlweLMrxmnpVlo+pP844URwp4p9G
	 MILv8NTKReA9a7vz7A8huLjGzCwiPEXYc3mW0gvAHX8/azugwb+Tgi/FqOESEyOSUIq/xf2BncZ9
	 9m26ENYI0ZrIB4E7YdytTSiU45cwzzzu1zZH3uLOpfuJPaSMgHjG9+f4If712p8XqGEJDF6w==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Date: Tue, 18 Nov 2025 11:18:56 +0800
X-OQ-MSGID: <20251118031856.2800796-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
References: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rydtuwnukw6dprknwte8imhngjxf8gbk
X-Rspam-User: 
X-Rspamd-Queue-Id: C2F7120002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763435944-91301
X-HE-Meta: U2FsdGVkX1/rHjPLXL9Sq01p3NSFpLCtfNdvqBZDZIRakEbLr4KJ0filKgKdXjhLMe5ZlWmpXbYMW0fYQoMCqRApvRy17vL3U5kzVUmg5qQAaW9p9dYBYQTJpWDmjUyCSzi30K4J/13ZJcnnoPRebBU0NfT7EezQiV6GL7X5rbU+gghDNxfKBxcpkzrY2HVG6IMSksZO8afh+s3VI9X0zP+AVzE0rGnZanjctdKAuBCX1P4qrLgTgYlC08QyzZwBLHq7yAXVyGWrsIVVRJ2LSQ5GbdD7Sm2K1S/qThuLGnT/QFfPVHtt0+lw/XDCpGDMm/eLOQ4jycNQS5HFFvjXIYrVisEB+lnr81WMe5SHUG//+gFb7a7OAui0g3pQaHHMFJyA9gqYH186aRg/D7DrXsRXlCWFnYfHTBssbH6VNXR+o5WG+xXVuye/NJVBAffej5M8mAASAYyciRKn+0zMDkUd4yvXfyYZ4SpKt+VYeZ+urqBgHe8Q3KSSzNliR4/bKaCC72AqDwfBbQaNbqutOv8MeezBsfrlB6tp6rRzaWVKEhEDC+V+Kvu3vhXZ1Ja5dG4ATHMT9pozEMVnMjwbsWHipW57vu4zaPsKATFv0lSTD3ygm0gkR0WBehV+O6mqgI53EBWtSuL3MZONQDtSqDG7RxDQQmBQ/xCty+L3TAqyVE8CIqHxGhrm08Fp6Am9mXtBWn7pBWRiSVq3BBhT4eFkxKm186CMn5GmqDmqtsGgZjKg6U/pHifDPjjLGOpfnHABCcCJm4jQ2Pu5jgee+pb/xyhBt4STgCqYdrZV/gkuWqIA+U1u3uOWL+GEfvKYNq3FtG2Q1gdl2RBxy6je/SHUpbKiJ/Wm99zew7Cw7v2SVPlEMPDZodNojWNY/wYmGlK/VMFjnavZhGL0IQDDC0F1e1i6/cBFLSNRi+tVm46TWISpYz+8QLAaxGiJTVFSRJS+LcPk+57R3C5ruhh
 3r8BpODC
 qUmKXBOwXe46FDoWS8p5ZmHCr8IgrF3eYu+kzsiF/aYtjg8Xkc5MzoM0lYe9NAtAxINPVfaR9AXstH3mQ3ss083hgXL0NzlQgATzJJi2gcX5zPsGD01rrxPnPzpTzCnxOBqamy6T2V6+Db3VENR4IAFrqZ5qu9GDaLSuJEjzEBhqBkEen8LzU11fldDJRzhwi+ZHlKO/71R1sdOv+YX72GUm4ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 10:19:22 -0500, Sergey Senozhatsky wrote:
> +static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
> +{
> +	u32 index;
> +	int err;
> +
> +	index = req->pps->index;
> +	release_pp_slot(zram, req->pps);
> +	req->pps = NULL;
> +
> +	err = blk_status_to_errno(req->bio.bi_status);
> +	if (err) {
> +		/*
> +		 * Failed wb requests should not be accounted in wb_limit
> +		 * (if enabled).
> +		 */
> +		zram_account_writeback_rollback(zram);
In this place, the index may be leaked.

> +		return err;
> +	}
> +
> +	atomic64_inc(&zram->stats.bd_writes);
> +	zram_slot_lock(zram, index);
> +	/*
> +	 * We release slot lock during writeback so slot can change under us:
> +	 * slot_free() or slot_free() and zram_write_page(). In both cases
> +	 * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing can
> +	 * set ZRAM_PP_SLOT on such slots until current post-processing
> +	 * finishes.
> +	 */
> +	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> +		goto out;
In this place, the index may be leaked.

> +
> +	zram_free_page(zram, index);
> +	zram_set_flag(zram, index, ZRAM_WB);
> +	zram_set_handle(zram, index, req->blk_idx);
> +	atomic64_inc(&zram->stats.pages_stored);
> +
> +out:
> +	zram_slot_unlock(zram, index);
> +	return 0;
> +}


