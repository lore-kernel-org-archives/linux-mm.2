Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACC8606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DWd0KxDa
Received: by kanga.kvack.org (Postfix)
	id 415996B0701; Tue, 27 Oct 2026 08:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5BF6B0703; Tue, 27 Oct 2026 08:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCC76B0704; Tue, 27 Oct 2026 08:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5D36B0701
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:38:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37DEA80987
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:38:44 +0000 (UTC)
X-FDA: 85368360168.08.6184301
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 191F220002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:38:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DWd0KxDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793104722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+2t1cyvTHNrJyCbVMQW5rekaM6HtX5EkecAGatJW+o=;
	b=xP1RH6H2sGjIXMk0R4N10BNp3vUUF/YliHxJ0aW7NkUO6KWE0S1ijaXpR75uuATCyplX5u
	97PRDtz5+k/XS9SHnhX/h9wvWgOmi56Vr+JVU1/9wluOku+tejmyIga7jKyld+2FeTHcYc
	Cn8S08dzS15r+sL9MudznF1n3rPEfWo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DWd0KxDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793104722;
	b=IaQCbyq9F+1ur+QaheFNzS0dpkOWh0+P08VYpjodtfco0J3cZ7JMFwB4qoQHBjd66380Xt
	+0c1UqKsDoERUYuj7lpkMhk0An1Ljm3PXZx9rsMSSJd3LtxGK9USS1Se/rjky7T4eQ7F/g
	aVC+n5px0DSOzV2//MIPrEU5YfnghJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AFB66022F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC7D1F031EC;
	Tue, 27 Oct 2026 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793104721;
	bh=k+2t1cyvTHNrJyCbVMQW5rekaM6HtX5EkecAGatJW+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DWd0KxDaK80pFuGqi90D4Nrp/O3Ay03rJVOcphlqDOpC5VwyooaMvPqtWSp7jcmOZ
	 lmtgIXSFL0cTE6mastyBXTv6cbOhzZ/7VWbHCt1yHtWAYgYpaXQOMMwafaE9Wq7lNO
	 llXJcTBFPjXt7iVvR3aWg8MbFbet73ELyp15wqg6WrA4PdpdvP7wA9J7bGrrVbOoGr
	 5VevwKY56KtvoYOk/g75qeX/6LhmyLcsSVuIGmD8JvM0sMDPBz9nruinq01rtU1Ust
	 HCKfQEUALjKYYA7rOu5rPQOnGy28tIIUuwqVDLwm3B4y+d7ifl0lNs7WsB0xocKHtI
	 3cgk4VtI0GVrw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5825B198003A;
	Tue, 27 Oct 2026 08:38:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 08:38:39 -0400
X-ME-Sender: <xms:TJvgak7JmRXSu5-X0Vdx9dcpIvf3ek5Qv3ccgTrK5K26CpZ09mW5dg>
    <xme:TJvgap0RaWPiLmBjI62Az9VRBesF0YOk-44p0b7RPnkAnfwFA8iHjubvdCn6IE0_f
    m0P00MdGHpAaiVg-nILXlX4ic1_W7u6wEXMIw1j0kQcodEJP-OiH1MV>
X-ME-Received: <xmr:TJvgar_NCGVhRTQ2gbWsHcxqKHeURzgP5Ky51kfmdxfUNHpuVyDGw0nyiuM>
X-ME-Proxy-Cause: dmFkZTFifNxF028tALiGBKVlh5Wy369MFPvYrj+99z7meFDB4RuiCUvj+DHIXqgXLIkCRn
    Q5TfW2Ea4AadTP3BtEjnoJG9TfURWYAWABlivX1ELh3+o3jlP3JbW5Z+GpCVf1ffF5O+JA
    RmA9DEKwKtT5+xShVrI/I/VUqcHsFsoYGBWTqAy23txKKKzUM+onqOvZLsU8TdVtJP4sNv
    ilZmCYPik+0kxktvG2u51a1liN8ZL5kGnlnLPqZ2DztMrPAbmms4mbDFVQsF1jwC3/NR+c
    v3Rkmyi4U27GqOzNMueyo695aZuHP58GJiOlPm8QHawcowZl17/kwyU9rbFZa56/RzCHZl
    nuDRVEy0Z0vA4R0t0TnaTi/b7snEFTXk+yVLC4bvUyBibMZ7+//zYmPQolg+Ve9k1Y8Jv5
    0tXp7K+ik8shGmUeFJuP+9R8YL5+NLXdykQC5X05s7xaE5Bem001Kt93cAYEZZYOnrriJV
    vvl6fSVBdHhh8YFhpiMyrU9vpt3EPJoRSGXHneUgNtoQqHiwgZOE3fl8gKjmvAoc9Fr6HY
    cXNWM5ppuUUoSBkTkNALo9rP3Brj+k95DE7sd3ueNQR/b87RVLwID2LTHk/N5h5Du/th9x
    TJnRY5oDK174qwrwit2pJ6C7DZ0I2DZQ+9xXHxPV2OPeXv1Mh8PgqGmPEfPg
X-ME-Proxy: <xmx:TJvgaitFia2BledahPcZx-R4DD1WuEaphsLwEIyLo5k-7Fv7bTvWww>
    <xmx:TJvgavpnAxQA-G6o8IEmGJsS9zvlg0t4INOvnqCC9kf9DCbf3ZyIog>
    <xmx:TJvgalHznjoNqsYjGYjHVHWl8DsGNN6ur4vT-7WiacXhKG029p_XxQ>
    <xmx:TJvgaq6F5aDKBTyU10Bq1MMpCEVHee22NHlqnYRbiFvwwnn9kamgtQ>
    <xmx:TJvgagBu3jBlt7weUEH_FyYjoLZ-l3wF-36MkLyg8_gw1ObMny_E8yNV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 08:38:36 -0400 (EDT)
Date: Tue, 27 Oct 2026 12:38:35 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: fix khugepaged_race build with older glibc
Message-ID: <auCbOg62Ym4Ic-qj@thinkstation>
References: <20261027122013.4286-1-zenghui.yu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027122013.4286-1-zenghui.yu@linux.dev>
X-Rspamd-Queue-Id: 191F220002
X-Stat-Signature: g3wq9twj7j8cde3a69j54tc8bff1zgor
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793104721-549049
X-HE-Meta: U2FsdGVkX1/1Y+T15+AHgetDR/7EhSnQPOJig7pnUevmdU+6oO8/4E627L6Tp4qtnySYW654Bo8BBBVTHNlWg2pQDl1A5tPVpD1CDM/zjyE0riayUixHFboyPVUPRSDB0hzqOWSD2UyCpHt1w2cNnmRJvHY+93iOuS7qS6n77eNZjE6bhkVFOuEfeoLeru7vGpAw2bDBx3IYTBce3XK7IBYwVx+s7qB8JLZ2SMj9/T3h+f3zrEVAyvaT2cjuG7SreZ8lZgJhb7RCxCEQusluft6TcjyrPy/vYQEtEgP41SlbxFJQ5zzf90GrSQXJ+hOafb/7fVN9aUPwY1pEeBdvhcoAW6TDmtnvqMu5M2X5q15vYGHf8fKytZ62YlFkoCOKD8IE+Hc+JnMLiu5XlBB7AAHqoZ4PcHfE0Awes/2vmrmXjqIGHD107R/hneYN4pNrfDqESE5h4m/YSTLvwVY42eRA1X4couqZVsQOwzoMPVwOOLKDtlwqPM2aKNVmllCM60G7ph3vNFVTiZb4uxVnLNlHrIoc8By3zBhCeeFa7JltqY+f0IZqolmwLfkRQSdebc2oetfB5yneIcPFezA5I2eoYpTVMODWOTbh0nNJkwuLCmABcwnR3laTJEGgHjR+WsfCx9KffdQFiNftwZmXjlBoWUmqsRuPcOrrZAeWfTUHzWeAypMyMnOvwB4kxzuX/WOd79z04UYB9PHmxOHlFm50LP5xTADCLBUB54tOSvkhn4f5mMZbXWG4db2GdrcG4MjtpxGihGgHAo9bHPHKCq+W53xocfEwEKAp6E54m0MTHDi6hoO0nNR6uv2GiyWGrAYJpJUShOliIfen0SIpiDTHFBVvbVE9DBsJTGlJcF98Ca9xq/FtDCEUM+I3jbFgAa2t2XJ8SjVKZfb+CJwaegL/E4AindwQy29atc2cZY0fSPv4VqRuw4GEXZWES9gHFBOwkHQ4feIVtJxmkpL
 +d+ilOqK
 +sPav/1NvpEZoCD2Eb82EHFsWogvfenXIozdhaqJd2riyjYFi1nQQDqfJqXqA/0UODN2+JV/W9vMDQ3IPcwv6LWQbIT5XaZWJEohmOwhaJMYSv/Gbh0vBqtzfJjBd2YPTEzWNeSCv9wGHSX+0Nr9hPaw9szsviNXh5XY2xDC4H0/Kz1cN0MsNoDm1MKF6MIL8QgqDK7fTGVWT4t7smouqxpNbxIsUf2Oi0UdNqAqIQX4/RAX8uwehf/xPRqzu64Iv77DyUrMFuv0Wh3bTN6gyA97uFNWZUm14yC1eo+kpUQpYOWt1upFItQArAJFVTOWKSCuF5iYcGdj6RTraI3TDCwpoNtbAEuW1mb2B74TyKinafpVzwCa7ibz1Kmwz059LsDPDiObdC+J38SkjF6v8Eb6XMIiXaRd0/yyZdlL4SsJE5D/7R6+txxsG1djbOxJUXpt2voU0oj+OUlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:20:13PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> glibc versions before 2.37 do not define MADV_COLLAPSE in <sys/mman.h>, so
> khugepaged_race fails to build against them (e.g. glibc 2.34):
> 
> [root@localhost mm]# make
>   CC       khugepaged_race
> khugepaged_race.c: In function 'main':
> khugepaged_race.c:506:23: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
>   506 |       hpage_pmd_size, MADV_COLLAPSE);
>       |                       ^~~~~~~~~~~~~
>       |                       MADV_COLD
> khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1
> 
> Include <linux/mman.h> to get the UAPI definition of MADV_COLLAPSE.
> 
> Fixes: 66c374464438 ("selftests/mm: add khugepaged race harness")
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

