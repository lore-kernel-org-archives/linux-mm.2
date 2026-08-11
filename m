Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3655C5CFDB
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F316B008C; Tue, 11 Aug 2026 07:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A500B6B0092; Tue, 11 Aug 2026 07:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968BD6B0093; Tue, 11 Aug 2026 07:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 773D86B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:39:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11F051603F5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:39:31 +0000 (UTC)
X-FDA: 85088793342.30.8A89C0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F52E2000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:39:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwOieEKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786448369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Krrkb4GTaAxnE8gRQpTXpOP7iACr+puNNwdjj+aGSmo=;
	b=yFq9IhlieA8skc/cua/QdigFbYWbAU7EbHK/pdfcLy6LnqNS0zDmRKkba7ZXu7Z4xzDSUB
	r6mRGV/X8ayeDvcgEoNG1g3eWOc+DAUOL0A/n89Zj3Vcxal/yn3irZZ6tzPlj19QiExx5h
	IfhZ+5E3KvfwGN+Sex6yqLED7cGUu7g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwOieEKu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786448369;
	b=0AjS31Eko0BGTTjmEY/I399SK+EfhXlk3ZpjnVZWICFlp+PasapnrPxFfQuqoYLygazyDw
	KK8AH8eH6l6Xvhli+lIuWPngZvQKn3cBcy8WdRTGjuvi3ZZClbKROTaoTcPm1kc4RzHDto
	X1TruKv7TN/DqJLMdvzmN6zQSPjLWh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECBD8600AE;
	Tue, 11 Aug 2026 11:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA841F000E9;
	Tue, 11 Aug 2026 11:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786448368;
	bh=Krrkb4GTaAxnE8gRQpTXpOP7iACr+puNNwdjj+aGSmo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gwOieEKuQYtmfuvad1CGHIB0AyEIzLKSuQMhLAg880EX+Uyoy3GAYdsHZDhjlPsi4
	 FWmUwjweR8Qfpfev+YibwTHYfiJk5qA5KUDhfQdIrDoFroATZesePISGR51n71SiFo
	 aRFpYjV1NAjlBgmZ4MIzJYwuMAPP66ufPhxW26PDEoGIa5GVr6wWL7GvUsv0kqh1Lo
	 cxNf1dnCttcC1Hg09z4ASiidq4i+ZxUE7WVgnvG6rwcWAvuRI90Sr5lOb0FYBgnANp
	 d4g0G9MaldKmvNQKU8P6U2sWNUObdH8cd7V/4PwW3MZEkgtlEuY2oa12aernvLFTdB
	 7x8UjliRJIwqg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  graf@amazon.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/2] kho: remove useless phys increment in inner loop
In-Reply-To: <20260807075128.542806-2-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Fri, 7 Aug 2026 15:51:27 +0800")
References: <20260807075128.542806-1-duanchenghao@kylinos.cn>
	<20260807075128.542806-2-duanchenghao@kylinos.cn>
Date: Tue, 11 Aug 2026 13:39:25 +0200
Message-ID: <2vxzh5l051jm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: d1sbjpwqchdee5ux5w5od4r6jin9kaws
X-Rspamd-Queue-Id: 7F52E2000A
X-HE-Tag: 1786448369-506058
X-HE-Meta: U2FsdGVkX1+H7QQJdMg96BSrFwZHvZNgU7rVtwGwGHZXQHvOlIRO57sHZlmPlNv0r8/nIlnw3e9O8NRyWS/ocs54a6MDLx1Rv4QyNu5mZiKsbwl3gtlH+UtuJOPTSvJi9+JfLpxt7Eiobg9hdqNcany99x8AqKLnHrVfMBx2vA4Dsf63qEIAn/sbmg22zHtJmsvHQkOm6MeI9WLSU0c/cuyop8hQpIkxDQoQMAj1Ew+sFJcYE80g2hNtJLirQyfmaDN88s+dr2K/X9D5Gw0QSD4fo8y6IpKRBHMhStl73wr1UzMqGHCN+PF/cRlEFI2AXvewbKl3KkaBLxlur891ImxQDy6FPE0VC990FeG292R5v9LZQ+jfWza8ocNhhjtxfCqXlu4xOvXnbWPodOPU6RAQtWrilVUp3K/Rt1oM9KtazhwbNJ2PPKgJ1iWAesmYAxzJMBJSoFUQIgS//PgNtKYLSK2nImd2hhCr73q0ytgW5i1yUz4Qro8OJJ2wpZ7AQD5KPwzGYYRmcrjI1aLNX9rem3SnMXTYLA1QdfwHwF/fWUa5iiXcFr1PdvW5yq43AAyOzkR8Wxdrw9saOUUwzORynyh6IRetHiYnfnkSOIwam8bd74jrGtfv2dbbO2rO3hv2cV4ypN85T33r7k8XnoVsTJ75bdetSEo+WEMpI2PlfAHMaYOnj+FCqQEFVp+evOc6d6okNnoGTz1NUQbouVOerTNOyXbOTLv3ATw6LJlK2oejjC+7PZT7+/4muDgqNeACWgujmT1cGABwVUnenvH9YahHQ4x4qxXaEy1/Fd6fWlEK3WiuVkmFjwIo6qNjK1V9n//PcHqF8nvBWdOWLebXYF0Us3bE+G7RCbbpFBmypspl8zjixauMoOmDP7j43zcfeNU7ycSYMPxktwVj2t19ADnxLfvbyBVBgYsoGh79h4tygdlaV9gX8F0Jc7KVnSmRXBXzFWl6tTdAbYE
 eFb9FDiO
 /+LKkzn7sFTSb3grtktylNf5FdfgsOIpU9/QEQxpN4JO21cyIwrxwDnm6xsV08th2IxsGHCx5f0pUSrKQhVVOQ9NCx3FvW+N7xTym1Hht4saojwBI4GkgVe6S9RncgYfTpDkZ293PhU7mEVDLyULDZGIvBZc8je2Z3X+5jCpOaAA9GexeYvsaU6TGmM7pRMR0Y4oZyBSvMHI4y9XuV2PHmaoEmiFpuQLJcQ4opsKM2rK7HKEdroyEeGVrRNPqv/ckT3Bv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07 2026, Chenghao Duan wrote:

> The statement phys += contig_pages * PAGE_SIZE at the end of the inner
> for-loop in kho_restore_vmalloc() is redundant code. The variable 'phys'
> is local to each loop iteration (re-assigned from chunk->phys[i] on every
> iteration) and is never referenced after this increment, so the statement
> has no functional impact. Remove it to avoid confusion during code review.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

