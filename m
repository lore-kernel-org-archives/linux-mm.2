Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DE9E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1546B0088; Thu, 19 Feb 2026 04:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755286B0089; Thu, 19 Feb 2026 04:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636BB6B008A; Thu, 19 Feb 2026 04:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF846B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:26:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE61CB9949
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:26:25 +0000 (UTC)
X-FDA: 84460675530.17.4494F0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7EDAC0007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:26:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKrqWnrx;
	spf=pass (imf22.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771493183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7mv0hFRO3e9tvoI6bGIilLs7hNCzopdgjvdBXxyH/U=;
	b=1HEDWPvnckC++QMfa+y1l/ig02+0jEbP8Q9+mGG+S9y3cGNqvfbUBhfl1iCLkFbIpoh+So
	5RSlgxv3u7ZZXKR5wGGLDmq9n/cwuD/PIF8wmW3NdxlNQDvCElVXbeEwqus09vEHkVAicn
	UIhP7b99dx0Gfgvq+cm7TPg+z8DxPTc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKrqWnrx;
	spf=pass (imf22.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771493183; a=rsa-sha256;
	cv=none;
	b=vyZQ6wOY+OAEYuzy/aj3MgZDbH7eqVpSl43aUkHH0BeXfgS8Og/vwseye9gI0/nuKvG8/p
	p+gi+RNNQ5Gv1USNrLGK8DJ9cIO3FZszNtODd3xvbW/Uf2/vWlQYFhjmUjtjvrCyMYcxZx
	qCi5ppo+YBE6xQsYy3v8eZGB5QOKOFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E08A60145;
	Thu, 19 Feb 2026 09:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64835C19424;
	Thu, 19 Feb 2026 09:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771493182;
	bh=9IclTx3lnPUxxtiARPih/U1FVwMbLyJFU7PQnzSllf4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=nKrqWnrxk/UF0dc76GuL2WEo9lMnE1oUET+8joSutIUpaRDwFkIK8uX4+648Vntz8
	 soSrP7DfJNcuaYzBuyopcgRG7XVcUvaD495M0EGVcBaKexwxKL2CDn7UpryxTuC8W+
	 z9lhtmdxX76GZPH9oBopTHBsdt4jH/kwusOZg0yf6gVpzD3RxeSb28rTwoW18zm14s
	 fgEMkOBatQPpfdQhtiKHraGzhWZXjkL+6qNJw/s0YBgy+BcS777batPgK6Nw5hrGZm
	 t5QEQTKTmNjxgSDYywE9agrNNwyUdq21Q1/IkRphl+TNllhLQ4wNalV85+Ne+/rMWf
	 iQaOMDcSnE5Aw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 47411F40069;
	Thu, 19 Feb 2026 04:26:21 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 19 Feb 2026 04:26:21 -0500
X-ME-Sender: <xms:PdeWaaL57vk_1COZZIQFjL4Dy6xZ6DXR_kBQO3NJwzcZYEacKHLPIw>
    <xme:PdeWac-p7pc2D-xHGqmciretbVvoYIq_sfUwA5dId5dNmzXsWVJtqUdoQDsOXF89F
    PXpgycYLGRTlaTH5sWZGGTvlMxDsEMYm-fueMSzm3SzVuNtiOeufg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehudeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepthhhohhmrghsrdhlvghnug
    grtghkhiesrghmugdrtghomhdprhgtphhtthhopehmshesvggughgvlhgvshhsrdhshihs
    thgvmhhspdhrtghpthhtohepkhgrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprh
    hpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhes
    lhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:PdeWaWGJ4JKNBbaRHtrJy2N7yubZn0XGriWmBSs-toscvywI4ZkQtw>
    <xmx:PdeWadsi3lp9f5SwXY3TIQUfXhVIO_zbp6ngv1WrTxToDj2Jf0FHvg>
    <xmx:PdeWaca6ucxo7Tk1NDYil-QaQxTs0hz21exYyeG1rUZa20e6MylB8g>
    <xmx:PdeWad4J2FByyZ4bSF2zAnu4_f7ZB2eQNSjwWnSmtHJb3JeNJekx9w>
    <xmx:PdeWaU-ya7pKWP8ckaNRTTuOvZYK7wSv-wmwkkV7iHk7-mUQmqagEw-g>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 27767700069; Thu, 19 Feb 2026 04:26:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AvPcN72_GPoV
Date: Thu, 19 Feb 2026 10:26:00 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Moritz Sanft" <ms@edgeless.systems>,
 "Mike Rapoport" <rppt@kernel.org>
Message-Id: <2f46f365-160a-4a06-b8cc-b2d94f68033b@app.fastmail.com>
In-Reply-To: <a45b19ed-149d-434a-ac80-4ea74a2e0f10@amd.com>
References: <20260217104957.249340-1-kas@kernel.org>
 <a45b19ed-149d-434a-ac80-4ea74a2e0f10@amd.com>
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: E7EDAC0007
X-Stat-Signature: csmoipdetg666wmanuqxbegk16zte65e
X-HE-Tag: 1771493183-270433
X-HE-Meta: U2FsdGVkX1+ZKk1pfhO0L2MB9vrinFiBi9B3K4nWMUR373OPKME/zf8PphipHb3YZGS+HhIvcxDGWAKscsjh+US17Hkr8he0sEd4+ZtUP1zyeTiRU3+NC/vPykMhwvBj9LQWNpgLoCeNsJKP51I9W5Nw0Vhpy9acL9ZBI1J5FCe2+M6qSf6nMDgpvfObWyqBTl923rO2Tels/l+ktYqoT+/zhqnauJMJ3IjjFKX6t6F721GvRmxEsEkICo6mFNywGPNEklkUWYHHTUFIOElzQZRPLno+1OR60+UM85+zDKkJIybm2Y/IJE2fzydBgVMMa2IReRhKdOoiGL2UPKIk354HR+3GDm8GWS3mcmAsX1zzUfxRbQDir862i0hp9+aWD+Vqsd6Zz/0tjP/MKr76A8xKMLves79qLJ97359iw4ayQ6w0YZCqYHEUo5tOZQVPN0hi3l3PpQCqN0+5ScC2qWH3OLYfVBLWbs+HQzG4riHCrP/ddCuOFeOfr3N6JBxca8rjA31FavoXSA/9v6xHzkBBljASWGWaUcmoCgTegnrWeqSQ1Q+Ow22yE/usYwsi85dYk+xiWTrkct8g8XTxjaKuVoxaUawgG4KVn7FOtwrhaOlmjo7tYu/JO+SD/UQVrEUMoTROsr4JaJ5P3JHa9Zr94WQuUn0hV4pFvLD2xLxu7t47qNa+l0sLS5oC2BMBr7AFo0AhAN8VCMO09doMwUofiMrNBYXn/zkGZbfLBx91yVx+DzM23Cn0bgWzooTa2zJouAEr15CBSCKmlMEAB+GeKjHfRdZIRwvZKu1rHcCFkmdy1U6a/GnnmTsnLiwVqObeldokpvYLia/dl/0GjavbFc3ycIXyIJVy61UYbnNYoqsGM+uzeARSALMbe+7IfQWi7IeHc/ow4ELf7qiEZVOBZS6GWpa17kR7yK+r0TEGpMxfXrCZF3vJBkjZ5BInSORpKgX1QrfRG16G8ia
 1asV5f8q
 SqQ/3VGkrlpc02u+AQdmmZO0Xnau5axJrL3BZnnZ5NGK3Hvg7Muin/Z+Xkd0BtEsQoeIdOuNpaSyDAvxTNIU4Rgy11/rv9GlM2GTHVnRKXRsWFW7dp0DFiORyTcDad9QIRdNU+EGhGCRFgJH7Vs/lyCyZ/Y61MvzNsJxgpSO2LyD7ILU2dRZaq63xZRLgqbftwr1OLGTsBUnW+YRFNcB4QHINzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 17 Feb 2026, at 14:56, Tom Lendacky wrote:
> On 2/17/26 04:49, Kiryl Shutsemau (Meta) wrote:
>> This series addresses two issues related to unaligned physical addresses
>> and sizes when handling EFI unaccepted memory. These issues were
>> identified as potential sources of kernel panics in Intel TDX
>> environments due to incomplete memory reservation or missing "guard page"
>> extensions.
>> 
>> The first patch fixes the reservation of the unaccepted memory table
>> itself in efi_config_parse_tables(). It ensures the entire page range
>> covering the table is reserved even if the table doesn't start on a
>> page boundary.
>> 
>> The second patch ensures that memory acceptance requests in
>> accept_memory() and range_contains_unaccepted_memory() are page-aligned
>> before performing the unit_size alignment check. This prevents skipping
>> the necessary "guard page" extension for unaligned ranges, which is
>> required to avoid crashes with load_unaligned_zeropad().
>> 
>> v2:
>>  - Fix 'end' calculation in the second patch (Tom)
>> 
>> Kiryl Shutsemau (Meta) (2):
>>   efi: Fix reservation of unaccepted memory table
>>   efi: Align unaccepted memory range to page boundary
>> 
>>  drivers/firmware/efi/efi.c               |  8 ++++----
>>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>

Thanks - I've queued this up now.

