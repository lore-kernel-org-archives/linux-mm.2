Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FCFCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 06:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A610C8001A; Mon, 27 Oct 2025 02:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A389D8000A; Mon, 27 Oct 2025 02:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975728001A; Mon, 27 Oct 2025 02:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85B568000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:56:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F8761603C2
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:56:43 +0000 (UTC)
X-FDA: 84042986286.23.E8A5024
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D0F21C000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:56:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QjcM76sN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761548201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uDlb6SOjTnJSf1qjgV8ADUvyCbUzEryN+f90nsF9h0=;
	b=Umrau4QlAiQzYknUFplT1hs6siH7T3Xtt+dWleFIfUrzMdLTovFrVg4CzIauwXiX0tIYvv
	3Me2gCo/934CqAjV/J1SJavWlkortVj3Fzo3QMWbZtFbtyYlxymIogtTzeJsKhsXq1GRYn
	HBWIJl/N96Bb+CYtiWAsqh/oDfuZqsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761548201; a=rsa-sha256;
	cv=none;
	b=LeqMe5aMQofN88wqz3kUT7EY0nB+2I3ODGLh1VwxAZ8LDG/jK5skrQIPQH4080Ng6VZBCL
	Ksaxvy8KwQVjme28SV4D6FD6567bdgOsqauUuvhyNpGbUftQSk13IKfcgaG/xG5VP/wwPh
	yd3TLGYS2BeQvLCGyyrNe3c7G8kG9fo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QjcM76sN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6FAD6053A;
	Mon, 27 Oct 2025 06:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D6C4CEF1;
	Mon, 27 Oct 2025 06:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761548200;
	bh=3ozifgAZ+YfM5vcU5H0evJlif4ITKFrtPaxgfYBxwLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjcM76sNfamPIkrR3/MQCp/WntCpIJUiYEpCpq/4JhWqemR1cIy/wJ+5sW7z4pqGo
	 X3TJ3oPuG8vIZ8sVRTz0+4JSnGa9GfwNZAYxHUc1xzqAA/aQMAGVc7dboRzEh6++GI
	 X7WZGWE8MHt7RjnZPj4Df4TM0UBatj+5rEJspgIubyJh03Hp1NR+qoR5NMvWnvDbqk
	 tUSLkhBsVUXu6eUq7/IYmNUdIpcwm0z1oA3jMsJmAT6PbZVKkSyaHZx+sAvqXP8Ih3
	 6Gm9Yrt8Y4A8kHpMb4UZ4KELC9L+yFyLWROSIOC6awBHXa2EjYJayQEA6BJkF1sOMK
	 RJoNydmW9CBow==
Date: Mon, 27 Oct 2025 08:56:32 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 8/8] memblock: Unpreserve memory in case of error
Message-ID: <aP8XoIJmefrhxpe4@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024161002.747372-9-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: rcrbfdfn9duc3i8pwuhujp9okzp7zgut
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D0F21C000A
X-HE-Tag: 1761548201-995885
X-HE-Meta: U2FsdGVkX1+g+7lJaejlqU6hCR2Pq2x2WQVXHgfYhm0qE9f1JQrtZDcZDLfWnALg3QTRGL7T2affF1R6agejqLMuwd4eAoqmmVPZYvZL3A8hDYn//1OIrGEbuEW+j1GjLQ29PbAEwTW5UkgMcUEtxfyOKWkLPPVdvhSU0j1490VBuOzYEOQ9DUiiu5vIz+uUghiBD6DCPFOVmS1UQBlcewBawurITTVvLdXFRVVvGvxoOEYS7xgq+T/PXPMLpd4ZZlT0wk3/jK3RcXR5jIxxrc0pBrf7pbW/8y1hQOQXPe2j5y+xirkFMwo4hKsdcivL10FAYEZbz1hpEHO2tdhOi3QaIeXl1YsNaGixdsoxjtwK+BRMEWU6pYs1geKH8ZxRW7PgoM7v99w0PO74IJL3YCZrH9JSghdWp0dC2XF8y5Cf+nRFRC3ikWxoLaYM70tLbqiFw6wuf+D5q2cfmivS/k55W/fYZ96X7ijAS7Tc+AghOZkf/bdme8HWN/IMfIew8uF6RkA6DyqnjLw6JGtFigDp3NzoDMT78Uo8ip67xCcgidFUaL0Pd5j7fd6tmm4Ym8dpJRLjXLK+QcWW9zSHQRgutbmgKROvgfQp1qgNUyJxSWAh2kFxRxHwo4YgaGtcsbaCtNL9YU/jCtGWQLCb96oj0hd3krSHwXmjshpQ7CgHVybzb7LdP6yUd0R4a06nmTq4h1VO9paN0ge395PZsL5HAxuMl3yChYRaxwYm1fUoFDg7v7lqvi78rXX0kVxi7a+AlDZ8e26rPIJ9tygnHNZIW02O5kbCcg5WRBcYGMx4kaBQZDgkrh+WSXwe1tn0hcm7breqg6xvFIOmgXGrOn90rBcawqVd5NnhRStbWK28ngi1ultasOHLpzA22EcQGLibY6frynn3roWfcpWlm/nsUwEkkW69B+ZaKKe3LcBXFoXa9PVx5xx1vkeXjinCOwmxbnaLnavJv3lcJPn
 0BDmnN/o
 87H/ZLUt/JV8eaMYKFpvY1bFFf7INo2kYW6nS1KOMJq3mlq8geFsiSZ+mr6BWxyVRY2JB8psUUne38cyYEdW1BQJf1Jfc7WwSvtg5S9z2ZqPPtMHysQs62FxQDKB+L0ACq2aIJstYA/3ODdwE1VIDc/LOlxhjQxoSu7cdZiaOSzAhEQmY6IfDaQbwE4Z3bRpNcYsTe/mrcNhypAxYtoQdO/MFL7a60EKlb3NdmLKD/3IojZytS/2Y96HBkoDoGSX/xMw9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:10:02PM -0400, Pasha Tatashin wrote:
>  	err |= fdt_end_node(fdt);
>  	err |= fdt_finish(fdt);
>  
> -	err |= kho_preserve_folio(page_folio(fdt_page));
> -
>  	if (!err)
> +		err = kho_preserve_folio(page_folio(fdt_page));

Since we are anyway changing the code here, lets use kho_preserve_pages()

-- 
Sincerely yours,
Mike.

