Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D13C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4989D8E00F4; Tue, 12 Aug 2025 04:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4186C8E00E4; Tue, 12 Aug 2025 04:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243B78E00E4; Tue, 12 Aug 2025 04:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060F38E00F2
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:14:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4E93115ABE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:14:07 +0000 (UTC)
X-FDA: 83767392534.07.F7782E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67083180007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:14:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754986445;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdS8cRXrb79Qryle3wWALVzssghNV8dY9EgSHNy03DI=;
	b=uhJmyLBO2e4+U/Etwt+iezxt+AflWyf3R5/9gN5G3d0RXYRzMA9BVydrQTW38PeRhSVBqV
	nGGhBkNpgy7u8MllbfBatyFDC7X6bOfy1HzKmjQ3RueziTA7aSCMcBglVVK76PMTXrQJTG
	J7vPaIS8Fx3p6Y02GTslfpjLs2Awo48=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754986445; a=rsa-sha256;
	cv=none;
	b=bzxT40FXAt2CROaa+BhEDxJ7l3LMpNHiRsRgPNHPKOhJAxxq0mondmm9qyiybTFNpoyKJk
	HL2vRMetBV6EJtGnBcsgDM33BUwS+rZ7l1GK79MW+/RNQbqA9YjCC0+4qo3zKg1mAd9CNG
	fdpmy2LU5viY7sTGW77QgrAe2tGvsBU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E7CE1F461;
	Tue, 12 Aug 2025 08:14:03 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 534191351A;
	Tue, 12 Aug 2025 08:14:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QtPcE8v3mmj4YQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 Aug 2025 08:14:03 +0000
Date: Tue, 12 Aug 2025 10:13:58 +0200
From: David Sterba <dsterba@suse.cz>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v1 2/2] treewide: remove MIGRATEPAGE_SUCCESS
Message-ID: <20250812081358.GA5507@suse.cz>
Reply-To: dsterba@suse.cz
References: <20250811143949.1117439-1-david@redhat.com>
 <20250811143949.1117439-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811143949.1117439-3-david@redhat.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 67083180007
X-Rspamd-Server: rspam06
X-Stat-Signature: rh81pcrxkhseheptpjeizd79d43ixj88
X-HE-Tag: 1754986445-883523
X-HE-Meta: U2FsdGVkX1+QVrY23+B4bwE2NaE6u3DHKQ7o3i0ej3zy2nW0g56QDKyVhAxhyQrXHfs2TAsnbDEU5ZNdQVqanpEaReQ9w/2Tq8fzHqQidIF4yiJxTBBZytEgf3PPPUG/01fc1aFlkgk7bl/ucg7MspqYWTfWYJkPHrhu8/SiZo7DwUGNS7hwLlL0kv90WKs8O7Qv9PvRrWVN+R7XQXcw1I4fdPFi0PnYmFBz8D8t1zGR09RhOl+5mpu00TNLdKickIwjYHABD9x1WDbJz1Hy1bV7SI80eyjulyNYIZUVbudxHMY3D6468vl+eP9NK2Dn9UbNGAuVTUJYpQCN8U6g9SsTN4naaea3E7T7KR4MVi7cmfhIDpAxoZCWLggvmnig9ddHMC0Okto/r7nYizuFRQMvb6a2LiHrSppeup/0EcRF1bceRSmopAu80fGbK2jw2AGSgTG1tWUcJkIzGvDX9SRcorTmYy0b3IpFfAjEoTupYZI+cCqY7dNMq7beoC6eLp4DJn7C4KJijucsJaN9PLUoikavnHphmusxnWSNczQ/gLDL6+KI9YoR1YEaHEBZ1fsZR2b7se1dkyfGmiHVppQlLvcokVcDL4/lMmWYHHGerclwKLKiKe/uqxdFOmUnvF473NkKHG0pxBfcFdkFowzu0KEFbIuNyiBB/xVDINQhds/7OdGOmFsWKwSLKZSqvcEjwEzFRxTuLb6XkkBoeMzkM8nTpG+F+EMDboH9X9XNKgFwZ9OLQ8jradQRjMqqTvvTZsey8BWGwyawq2pGvqQ+LIzZ8ebFSU5VM7DMWNvXg1Jc2VvfUndKLijptPCkVHdluDOp1hFLHjp9UTXRB5sczcRljnMgSHS5lZ/HcohfvkQ8SShqkKjRMgU97UAZ82Di/cHcr35/OJNZVvDXxgXZY9y80oN96Y1sBvWB9b9HYDSv5TkNb98KX8p5gjrMiRuu+sOG+IQtFhWutHP
 fccC/az4
 0fkoo14MdWJBvRcZXOligAUI2tzkfptmggcUv3Zw+0A5tdWJLZ/AmrClDWxL+etw+HwtqFfTtS+Z45MTFGTxlpnnHy8JkIts+14thSNg6wAEvwxh+Yf2tlRIQ5psI912Lqk1B25w7SytuL6HFQ1+rf6ngUmBnFlGvMBtOsB69MX1TWEGZgeDEQGCc6ZmsCQoWCY6L0kwMXYOJpoT2Y8spBwhhnHBPZDicNFDi3v2dfOv2esmv4S2bJ85yX3lIVuKQuE3sGz5LRCP08D/LwxCISy7f0ZaEBxLpHoO32C7pl/WN+Jn5pJW85f64dS2W+D/2OO6m9p4/hQAElBPczRRhrrYrOyezqGUe6W/dwYB4cqtrAudnSGGjCblqOqYWS2uADObJvpAKL/MWehcncIrYh6lw0KFCvn2/DqsLAXS07G0vdJLa3uxTW6WAWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 04:39:48PM +0200, David Hildenbrand wrote:
> At this point MIGRATEPAGE_SUCCESS is misnamed for all folio users,
> and now that we remove MIGRATEPAGE_UNMAP, it's really the only "success"
> return value that the code uses and expects.
> 
> Let's just get rid of MIGRATEPAGE_SUCCESS completely and just use "0"
> for success.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/cmm.c |  2 +-
>  drivers/misc/vmw_balloon.c           |  4 +--
>  drivers/virtio/virtio_balloon.c      |  2 +-
>  fs/aio.c                             |  2 +-

For

>  fs/btrfs/inode.c                     |  4 +--

Acked-by: David Sterba <dsterba@suse.com>

