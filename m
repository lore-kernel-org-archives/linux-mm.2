Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FB6CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336776B0005; Thu, 28 May 2026 11:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECED6B0088; Thu, 28 May 2026 11:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD316B008A; Thu, 28 May 2026 11:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FAFA6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:08:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ED831208A6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:08:11 +0000 (UTC)
X-FDA: 84817159182.24.1C39FDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D818A40009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:08:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GstNKpFJ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779980889; a=rsa-sha256;
	cv=none;
	b=IfOpSPI2d21UcxlZeaI1AXSCMy+QDA7xotsxRJFsD0NvNETgesTKe5yoxTjSloGTj1lrV4
	Jtq1nWAT0/MwCx7WuVQPnw0wl56gKdWFy7wCiQ1sFP6YIfdpthONaEl7mIqpahC/3s7ja8
	vH/TCM0ovv8/8FjwfAChvC97Nx6QQCs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GstNKpFJ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779980889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+m7PVKaXI1aH5GvoQay43qZF0QetiKnHaFlSk944tM=;
	b=ztSJ8cIUOP6+k7QjZ49Nw/UtSmSvDSn9HJaXckRlJUnOZrTp2/yM7c/kaSW/xFLUV9OLe/
	MotxBS1A8Mp3oINxlmJ7HgI6lExEIfjH2DeGanjgfnbepKeVbpzyDBl/jAHRRdUBN3ytpe
	pZ9JmxeQDhi6T8uoQ8FS7sYmd10PzFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54D7E6020A;
	Thu, 28 May 2026 15:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB471F000E9;
	Thu, 28 May 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779980889;
	bh=p+m7PVKaXI1aH5GvoQay43qZF0QetiKnHaFlSk944tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GstNKpFJn1BqMn29fmUnfaTEeEKBSwtxZLRMmYGXQIIe/iiAvmyTQ5W0vzYGtfV/c
	 lNeROYsbux3poXkKRbI3sTDTWukWkEpIJktoJPH3pozN7pu6Au6jl8ZY5DLue6OQ/3
	 /7h+poVvHEHTtTAKGMesvcEtrlVGjfGBHLdQmq1oaw13lf9+/29IRzuPbZsMg41zAz
	 +Hvqpa6D+ml4XLqTjNrBDbG++CBK3bzgMYTwJaVIpuaE+OgPKRzpYF24YcqyN3qtb8
	 CfVoubZN8+rAsi9TVrxzsAkVCshz99GWbpTCyhXh5zj2IgxvHG/x83wbOnOT6OXjAZ
	 NxOjNAEOeYILg==
From: Mike Rapoport <rppt@kernel.org>
To: kexec@lists.infradead.org,
	luca.boccassi@gmail.com
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate: document current compatibility status
Date: Thu, 28 May 2026 18:08:02 +0300
Message-ID: <177998087846.707577.12006390274464324360.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527153725.1770394-1-luca.boccassi@gmail.com>
References: <20260527153725.1770394-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D818A40009
X-Stat-Signature: feubcwd5s7jjc9gob565xx3p7f65fzyo
X-HE-Tag: 1779980889-689117
X-HE-Meta: U2FsdGVkX19Ur1ONWtTZ1i26S+m7A7rhvHZCh8EUPOYFi9c+V6zYCRxI+HBIxyEkHyWnVlw3k/YKCVOLxmeEloTRxxcQh3KotL7CsdREjySXsH+URmyuuUGUeUsPME1r7AIZxiOAPak4pFQM8vreFHHyFYrVFm8dxiU70prSy5VomwQgU98y83scuZU/IZ1lKdD2vCxGSunezO/dsQEHAWixkNctvVAyw5PRxiQ1xqIFPETY+AHeXIsl7rddz+02Aj3yszCUrF8sDMZI/F9ee/SNtE5Sc27AKgBk1OCJ2LXGUDtrw2pJ7foI1MxL6xHeROB13fDNB3EJ4K75HKEhb1irBi+FIJlMCNQiRVn2OqzULRwb42DmmotKjPKtlOpsFPDcX0VKnKn/OgdcuKx0CiWic2mpa5710Yc2xhg9rngdK2f0eftUvRIqPN6Md/shcN0DYh3GOFJjrUQWsufyiH22zLamMcMuPBQyPBPGOyYKIUcHhn2q+kbJS226t1j2sjpCUSnegxgh/s/Ex8RR3HHmY0iwbu0pZcRcq1DcjaprC0VEfPTy+tIvbQiZJnk2ea3FjhkfEurFZEMjZs9q6e3nBE4szkDhUNsZSaXrT+RnlAVactsD4qBqMPfS8E7akI7nqiPQn/TkE/6bBPWsY7NzSETWmNFDa7/mYEexHefy6Xoyt4Avl9/YcDnjg6iAbNDUhi1wJAAZH9rMh1GBFLErwZ8s7JkiD/7s7jmcC3Hl9zKGRInglWpL6JyFx2MQr88aEK2+TE4YMMDIxAIdV796R+o7wLN6i25leZ799RX4PoN9hTuYC8kJe08ve+BlU2bl1ngC6eofH8rCn8U5IAkKa30LIZw6+d1mKcj0JGJbWQwf8IkyZlVHRBHVTJreGXFpaSkVLNK/87n3pg9I7se+vY+5S6ntpcISJd1mNnlvGpp09OdCW57nje7pIOGTWDTd3Saj1Jd/bi2pQnG
 feaAacU3
 DuBbhO+E4kDtYP3uJm6Rg/s5jEWP7IMI9Ctt818ywEWJVt+R7X3N7cKoeE8h7sqTeQv7CG30FuivlD2zCayfynVf5VLuCpOFOCP4hvLbgrTbORAsa1NoXJ4PLX6dWN9JQTSMhyqyTrF8Cgioft1WbL6AvNV/WHRr3O+wOvAcCMxtTpzdlXiWBUJg9Pqm2GH8YPwjusth9WsamXnDfsma8ufvJvqTI2+ZkxwVFLELrwmlam7iIFTUkb+eZe9A6C3Gy0hJjQwc1MrWIuoW5kirugBpbITCcbbIl0gtLDEteWgTuqZIBUgVh0Yk6ENi8H3nPf7x+eHQV4J3/sQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 27 May 2026 16:37:12 +0100, luca.boccassi@gmail.com wrote:
> We currently do not guarantee compatibility due to ongoing
> development, so mention this explicitly in the user-facing
> documentation.

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/1] liveupdate: document current compatibility status
      commit: d72c0a7b321cfe3a3cb510c599fd5e9cf3df24fc

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.


