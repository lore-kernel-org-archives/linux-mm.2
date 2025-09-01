Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0D4CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF568E0017; Mon,  1 Sep 2025 12:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FFA8E0003; Mon,  1 Sep 2025 12:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E598E0017; Mon,  1 Sep 2025 12:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E355A8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:23:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6551E1DEFCD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:23:41 +0000 (UTC)
X-FDA: 83841202242.22.E3D9ACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F13B180011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:23:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IC0bYdjT;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756743819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOjJVTFDuR9+CUFhWs5E7drx07lJk894wltLSnKNQS4=;
	b=HFKtLPz86R7tscKOWVoCcajfP8YdQGck+2EG5QWQYAOuZCLft+P8qMzKzb7fC2iW4gHkY+
	XbVvtXR6BTZ+WprdohH0F5K03rFUB65wQ8u6kFuCEP2ZlyLnRlTfBxByMyvE68x7AFGxqW
	e+J4mpsDCmTGq/RNSULW6yI6h0iCeIc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IC0bYdjT;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756743819; a=rsa-sha256;
	cv=none;
	b=CGfidoRbGxBkAx7M6Fqtl02p8JCVm1wYTZnoiatUUE3w8Xndch8YwYqu3es4xjqBMfjMEM
	O5IApP10Jjz8foX7BoqyOP+WwI+HSVNxsehCZRbaioO6YpUKcJV0TSkfoSmuNIeI7jkVvN
	kabd2zP+4y3E9TPFwbdP5Y1VXkyUiKs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7646D44DE0;
	Mon,  1 Sep 2025 16:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4E1C4CEF0;
	Mon,  1 Sep 2025 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756743818;
	bh=xXNMYxeUtrPT4DN76aplpZeN8UnkslUNoZEbarD5RAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IC0bYdjTaLnYXvKhfLlUnPms9FmtHm4xOtQJJVSO6DQpdytk6rYZjHGnqqjYm4HVj
	 S0XuCekWHj19c74E0buaHpy/u5gTOdn6UTiV83sq+04+OGJLP7bgv/RUseKsFBRMi3
	 vVIqEHGk6iuEZB8ayAg27GHA387gsmzPtP4xor3EyrLiwtysE9lhJAHYiWWSaSCSGG
	 owfP7we/gtmDXLd4HPbSkHxEMfF2vJXqLD1ixH/6jvietSz7mE8dVU8pn8PcBgZ2Io
	 SrqpD2E5Yh/tSDxNqdGRKr3r/PoVWLPQLLUH5bx4dQxbxEvDKrYHOlDen3eoSeGW0W
	 T6JnpKlHJIwdQ==
Date: Mon, 1 Sep 2025 19:23:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLXIcUwt0HVzRpYW@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826162019.GD2130239@nvidia.com>
X-Rspamd-Queue-Id: 9F13B180011
X-Rspam-User: 
X-Stat-Signature: u5kounm6bn36kihjhcjqt7w81ybkpfjk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756743819-297863
X-HE-Meta: U2FsdGVkX19F5JjK9w16JTa8g23Mhoz+RpjGX75wdoQ2f/5g4ZfmKA2kq6uWTX/xyt+rGePtCIsXjn78GWJucVjp4ieMVtw3ijgTwZHcUmf9wfx85+IqmCAfsm8uRI4iT4jKW0HvWI0IlmqrFKzy4ure3gWF1du1i/thuSNrE4v13KS0e9+MscN5fbfKl3TEyr0WoKp7jP3Qr5iuoU0h3FYp0pThTrcv/PggLbdsLusMITu5+wKnZP+NKF9jgS4V8jY31JoQAxVU8AzZ+D56fygx+zEq2E2nP53zCiZciOY6UHE7BpwhEs3vDj7yU61BL6hwhcItcdoeQIvuEN+Rj6TmozFkfs2df3HTY+ghYhkl8aP9pwm1Ew8MAjKB5XK+koZwNjeMAXK1ZqmrEREwFHXjDj+GLBNtel+kyKkGcbaTj4k2O3I601JFRTDwO38ZpovjKvUun5u62kGxeOqtS0t5EBSc5n7T48ijJx1OlswJMGB0CSbAgfSgoOim2E762F+/hJk1xVCT9qgADi/8EQlvepUDaxrFLoq1JKCZAUgGOit5UmqITTPkN4Wx/C70pAffdAFTj0qYLAbN6w48S7OSqIR7EAR7IQMgZAQ1BhtUKAq2FfUUsNJrlPTT/aNYH1nAx84vKUOj99/rC0aMuB3FLA/8uivFngp9L9kuLulPUiqytY2x591UywgNzwKsxe8nSMkUanSN+y5wkKgwtHXwQiwQYEScaSCWQnPzzlj8Da2HtPsiKuz1vFChcs190iV1LtAYaa18ScanjMbtfIZfsSpnW8jr2zHkKiPOFzH49dUTVUz0vvREay4tW7x99OUwEBpa7YwGKCjP32/xVUFfp0YJsRijMAkG1IhJwLE/rLnrS2Hzh5PWy+FhrxovEHDfbVvuzbH1X3xmW/WwG766KRfi1BF9IkFpgbvbw2WPeOhZ5TWvyBr36Ozw1+gXPhoS/ldXbI3h4x1LXpU
 GuznGRQ5
 yImO3/SLESrRF3SaDdlraNaF02XITscsaahJAfS7ruOaTtVGg/Wsd0odA5wyJUffP9cuOC67yTfXypqx4GcRCAn3CWEaTQXULff59f+GRy8l/NcnVPag3ptlpFTqahy4O+rMO5L85r2pCSuMLzbboKBla5PNs6W0XpUvs92CHnYkpQdgrfUPLjchGDDhPCg0NOD326yz1F/H42b4wigvk3UzNxvsF9rIgt4Q3+Q7tiTv1H3ekIeH9pAxJEszfgacbQnObHd7Lw4M89N08liBtDNfZpwOJBAYH2fPeKOKT4x/AxyyBzmQLcusVzHQirW7kacfn+XltzZvpbw8LEdNUXKngcXdfCTeNAgbG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> 
> > +	/*
> > +	 * Most of the space should be taken by preserved folios. So take its
> > +	 * size, plus a page for other properties.
> > +	 */
> > +	fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
> > +	if (!fdt) {
> > +		err = -ENOMEM;
> > +		goto err_unpin;
> > +	}
> 
> This doesn't seem to have any versioning scheme, it really should..
> 
> > +	err = fdt_property_placeholder(fdt, "folios", preserved_size,
> > +				       (void **)&preserved_folios);
> > +	if (err) {
> > +		pr_err("Failed to reserve folios property in FDT: %s\n",
> > +		       fdt_strerror(err));
> > +		err = -ENOMEM;
> > +		goto err_free_fdt;
> > +	}
> 
> Yuk.
> 
> This really wants some luo helper
> 
> 'luo alloc array'
> 'luo restore array'
> 'luo free array'

We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1

Will wait for kbuild and then send proper patches.
 

-- 
Sincerely yours,
Mike.

