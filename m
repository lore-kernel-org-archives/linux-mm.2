Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1B6606A336
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 07:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=g6DzDdfc;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=g6DzDdfc
Received: by kanga.kvack.org (Postfix)
	id 41D3B6B00EF; Mon,  9 Nov 2026 02:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6346B05B0; Mon,  9 Nov 2026 02:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248516B05B1; Mon,  9 Nov 2026 02:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC2686B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:53:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D5EE1405E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:53:23 +0000 (UTC)
X-FDA: 85414815486.05.E505C39
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F64F40007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:53:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g6DzDdfc;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g6DzDdfc;
	spf=pass (imf27.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794210801;
	b=BG6M1jZxRYmPz45HA32g0PcTLfcMhdcjQS83JkIUcsSL90lAijt4GOZxWRQgpuou7HYdUf
	cBIhpm2wBUJtmaXpFF9GbsDivVF1LdErz4C+YJ0piwDbcY9b6mQakAhZvB9SVF+2qzuCtG
	jiOiFgJLDIlsg+biIV4fIN/rU/wgEmc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g6DzDdfc;
	dkim=pass header.d=suse.com header.s=susede1 header.b=g6DzDdfc;
	spf=pass (imf27.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794210801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtwimrsAGfjjluaZ29H+iIKzD9a3mq5Gyxp1CKu0/S4=;
	b=gri6D1W/WJ25gvnDm1nvg9Buu2Hw78eqJjxk6AfkHyY+hU3l42WdPTdcn8Ag1FS64gL1cJ
	hyr8RyGwlda7lMN0jZL5U7W5FgNpbffjDEGVWiIfVMZUvBuejgykse6+KXmV6Lb+eCJqXj
	ekGfB5ueV3tnuuGYnIyHbVLG+8v37Uk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2F3F21F83;
	Mon,  9 Nov 2026 07:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794210799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mtwimrsAGfjjluaZ29H+iIKzD9a3mq5Gyxp1CKu0/S4=;
	b=g6DzDdfcnRcM33YreK2ahQsBHkXEbLPIgPFv9GPVarTdwsPQr2CTIsF55ENSLzdf38DC5s
	npi7JRAh/4EppTiPS1/9LSZ7QXBfih7Cv5u+iLWv04iPb2n9fQTbmef45IfBmsI1M9Pxsm
	mGFFaqOrG219P4NlTHxK3DLrTjyISYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794210799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mtwimrsAGfjjluaZ29H+iIKzD9a3mq5Gyxp1CKu0/S4=;
	b=g6DzDdfcnRcM33YreK2ahQsBHkXEbLPIgPFv9GPVarTdwsPQr2CTIsF55ENSLzdf38DC5s
	npi7JRAh/4EppTiPS1/9LSZ7QXBfih7Cv5u+iLWv04iPb2n9fQTbmef45IfBmsI1M9Pxsm
	mGFFaqOrG219P4NlTHxK3DLrTjyISYE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6749A13319;
	Mon,  9 Nov 2026 07:53:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZaOBD+978WrJRwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 09 Nov 2026 07:53:19 +0000
Message-ID: <7af392b9-0cf9-46fe-a820-c994942893fe@suse.com>
Date: Mon, 9 Nov 2026 08:53:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xen/events: replace __get_free_pages() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
References: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wXW5pNoOVuHMY5I23DbFQuaD"
X-Spam-Level: 
X-Spam-Score: -9.80
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F64F40007
X-Stat-Signature: bo4oq733s7xzcy9mud49erxqmqgu1c87
X-Rspam-User: 
X-HE-Tag: 1794210801-443852
X-HE-Meta: U2FsdGVkX1+LJZ8OTxOUFakPrFK56nTw0IQFHlozO4ElQcOWakztQRMR0cwKk5DV98dzhR/n0jc0scsow5xHluZJvf+QYZNI5psvQY1R1IFbU4lDQWRM+YFmQv1Ie+Bn3xeyZGR755SB36rqvR0nBPOhN5bDM8wfuBlX6izsAhzlqjS7gHUcuMCr+5rl4XaOq2u9ZnSv4wLDOz9odxO//NnE/HAoQiwBQ8+PdBDenBbyvh5Wpt1rK28O0zdh79RDp9EyojhUvNMBEvBNuWX2p8P7SBqYGnqS/+jI1ffH0ACfHzkMsXOgb+Qe9Sy15xFilc5P7Bu25a8jXc+UdHVQ1va+zhCXHqUbXgEpVbbW5wtpqhL9zAIY3x40f08SjekE7vKyNiPTXOrZXUIviTqnIGvLCarK0bV3ELXyXsj37VrPaJHMwCF2yEbAS2ig2eVu1je4qZzWHZgz6uCF1uNkuu+J87ze6WQyYwhgFGF7AmRAEalxRHrbV6jkYyP3LDsTMYAzW7MSbDVUC+9tiQVReHiOG0g5jwPkUVM+lE6a9jfH/Axam/i4FiEVvt2Au0zC7b0HiTSehJa12cra1dCairJNAgzOufDss1VufYg62giDmlrqdNFQnAxn3Ykpkc6OqeM8+M8kiN/8YFXNDg16uQHFZCw0T1FVNVtbECjRoz18bENAqhC9yjGnkbnDTg8bQ5VfChmFZQl9dGnCCCyPoHQjUWqpjkLXB62bULo80x5S6kRpWG6i8gdkyvITgQjXX5cbQgCyseuLcFbCUSBJChpANzjlzUyaU8yf0jXxkcClieYJkx4uSwVJcDbvDM5tzZlYwMSac3u1nLtEkmU4UXRZ32f70s6bsi4zDl59XiF67jJ2zcl5kz5tyFb7qMfhBZuQ4JIlmE0H1vr6Zii3j02Oc4s370beiQUR1KrTaqPwoo+0618M+smFN3R4l1i7yN9EbeOk+JNlrpvUnI0
 6ookPJR5
 ESV6hsRyXCTY4+L1T4wolT81xo64qotY+GiL8eW1YwI0RTDj2c5QkwR+S+jg6x53qlgn4Ei2SKqWww055F68wPN4z7UiuMubVSg8Ly5srBwUjg+fwhQE1A7AMzY5s06bRKrTiUX5LqhuQq1r7Uwvb6jhDFgvLuBt35Nn+aCcSdgO6fLnxGU7zI/l/+3JaDsZGFJRPlki6PmIm3sd88vS+2Zm9D8Xk6smkdJ2SBK45sXW4CHZsnBiqhn0r2pVBQ3Y53za2E/Npquh4gTDISDS2ZcVRrLROAnnZFRQUkPMeiFY+kQURSzGq5QkGyl4wrgOhWWYXNplBMkI54FZ5ht0uuFwRmxjOloKYL6YrzPp1adCV8Y7T6/3WMaU+Y9Yw/iVX2EoGWavvi+ZoIHYVsc/2GsJ0623jtLATAVS9nLLxttHbRXoLcwjQVcjN1U3d+EYbWVTBa4fHp7iIo+MLBFaQWAetPv1mPaJd5Sfn+icYgMr4qXPGQugdzlcxZTJZ1sqPJz2lxoQJ78jgW+zFYjkrf8kZLFy6B2SchV7hfie2fY25xizV08jT+Dc5p24NMFgegm4puJ3oZyYn18gheSMaXY+XIvDCTD3r3MckuBAVZCOkjbeIHwuD9v7TMNMFUI/QKe+SrqvHdTOyIPu+2wHBAr0jdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wXW5pNoOVuHMY5I23DbFQuaD
Content-Type: multipart/mixed; boundary="------------9CjsJxfyxMmK8BT64s75qaM0";
 protected-headers="v1"; hp="clear"
Message-ID: <7af392b9-0cf9-46fe-a820-c994942893fe@suse.com>
Date: Mon, 9 Nov 2026 08:53:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xen/events: replace __get_free_pages() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
References: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>

--------------9CjsJxfyxMmK8BT64s75qaM0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMTEuMjYgMDk6NDIsIE1pa2UgUmFwb3BvcnQgKE1pY3Jvc29mdCkgd3JvdGU6DQo+
IHNldF9ldnRjaG5fdG9faXJxKCkgYWxsb2NhdGVzIGEgcGFnZSBmb3IgdGhlIGV2ZW50IGNo
YW5uZWwgdG8gSVJRDQo+IG51bWJlciBzb2Z0d2FyZSBsb29rdXAgdGFibGUuDQo+IA0KPiBU
aGlzIGJ1ZmZlciBjYW4gYmUgYWxsb2NhdGVkIHdpdGgga21hbGxvYygpIGFzIHRoZXJlJ3Mg
bm90aGluZyBzcGVjaWFsDQo+IGFib3V0IGl0IHRvIGdvIGRpcmVjdGx5IHRvIHRoZSBwYWdl
IGFsbG9jYXRvci4NCj4gDQo+IGttYWxsb2MoKSBwcm92aWRlcyBhIGJldHRlciBBUEkgdGhh
dCBkb2VzIG5vdCByZXF1aXJlIHVnbHkgY2FzdHMgYW5kDQo+IGtmcmVlKCkgZG9lcyBub3Qg
bmVlZCB0byBrbm93IHRoZSBzaXplIG9mIHRoZSBmcmVlZCBvYmplY3QuDQo+IA0KPiBQZXJm
b3JtYW5jZSBkaWZmZXJlbmNlIGJldHdlZW4ga21hbGxvYygpIGFuZCBfX2dldF9mcmVlX3Bh
Z2VzKCkgaXMgbm90DQo+IG1lYXN1cmFibGUgYXMgYm90aCBhbGxvY2F0b3JzIHRha2UgYW4g
b2JqZWN0L3BhZ2UgZnJvbSBhIHBlci1DUFUgbGlzdCBmb3INCj4gZmFzdCBwYXRoIGFsbG9j
YXRpb25zLg0KPiANCj4gRm9yIHRoZSBzbG93IHBhdGggdGhlIHBlcmZvcm1hbmNlIGlzIGFu
eXdheSBkZXRlcm1pbmVkIGJ5IHRoZSBhbW91bnQgb2YNCj4gcmVjbGFpbSBpbnZvbHZlZCBy
YXRoZXIgdGhhbiBieSB3aGF0IGFsbG9jYXRvciBpcyB1c2VkLg0KPiANCj4gUmVwbGFjZSB1
c2Ugb2YgX19nZXRfZnJlZV9wYWdlcygpIHdpdGgga21hbGxvYygpIGFuZCBmcmVlX3BhZ2Vz
KCkgd2l0aA0KPiBrZnJlZSgpLg0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsLzYzNTQwNWU0LTk0MjMtNGEyNS1hNmU3LWUwM2M4ZWEwYmNiZUByZWRoYXQuY29t
DQo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgUmFwb3BvcnQgKE1pY3Jvc29mdCkgPHJwcHRAa2Vy
bmVsLm9yZz4NCg0KU2hvdWxkbid0IHlvdSBhbHNvIHJlcGxhY2UgX19nZXRfZnJlZV9wYWdl
KCkgaW4geGVuX2luaXRfSVJRKCk/IEkgZG9uJ3Qgc2VlDQp3aHkgdGhpcyBpcyBiZWluZyBv
bWl0dGVkLg0KDQoNCkp1ZXJnZW4NCg0KPiAtLS0NCj4gVGhpcyBpcyBhIChzbWFsbCkgcGFy
dCBvZiBsYXJnZXIgd29yayBvZiByZXBsYWNpbmcgcGFnZSBhbGxvY2F0b3IgY2FsbHMNCj4g
d2l0aCBrbWFsbG9jLg0KPiANCj4gTGFyZ2VseSwgYW55dGhpbmcgdGhhdCBkb2Vzbid0IG5l
ZWQgc3RydWN0IHBhZ2UgKG9yIGEgbWVtZGVzYyBpbiB0aGUNCj4gZnV0dXJlKSBzaG91bGQg
anVzdCB1c2Uga21hbGxvYygpIG9yIGt2bWFsbG9jKCkgdG8gYWxsb2NhdGUgbWVtb3J5Lg0K
PiBSZW1vdmluZyBuZWVkbGVzcyBjYWxscyB0byBwYWdlIGFsbG9jYXRvciBoZWxwcyB3aXRo
IG1lbWRlc2MgKGFrYSBwcm9qZWN0DQo+IGZvbGlvKSBjb252ZXJzaW9uIGFuZCBnaXZlcyBh
IG5pY2VyIEFQSSB3aXRob3V0IGNhc3RzLg0KPiAtLS0NCj4gICBkcml2ZXJzL3hlbi9ldmVu
dHMvZXZlbnRzX2Jhc2UuYyB8IDQgKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy94
ZW4vZXZlbnRzL2V2ZW50c19iYXNlLmMgYi9kcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRzX2Jh
c2UuYw0KPiBpbmRleCBmZDE2ZDY1MmM4MWYyLi44YzM3NzQ5MzQyOWI3IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3hlbi9ldmVudHMvZXZlbnRzX2Jhc2UuYw0KPiArKysgYi9kcml2ZXJz
L3hlbi9ldmVudHMvZXZlbnRzX2Jhc2UuYw0KPiBAQCAtMjMwLDcgKzIzMCw3IEBAIHN0YXRp
YyBpbnQgc2V0X2V2dGNobl90b19pcnEoZXZ0Y2huX3BvcnRfdCBldnRjaG4sIHVuc2lnbmVk
IGludCBpcnEpDQo+ICAgCQlpZiAoaXJxID09IC0xKQ0KPiAgIAkJCXJldHVybiAwOw0KPiAg
IA0KPiAtCQlldnRjaG5fcm93ID0gKGludCAqKSBfX2dldF9mcmVlX3BhZ2VzKEdGUF9LRVJO
RUwsIDApOw0KPiArCQlldnRjaG5fcm93ID0ga21hbGxvYyhQQUdFX1NJWkUsIEdGUF9LRVJO
RUwpOw0KPiAgIAkJaWYgKGV2dGNobl9yb3cgPT0gTlVMTCkNCj4gICAJCQlyZXR1cm4gLUVO
T01FTTsNCj4gICANCj4gQEAgLTI0MSw3ICsyNDEsNyBAQCBzdGF0aWMgaW50IHNldF9ldnRj
aG5fdG9faXJxKGV2dGNobl9wb3J0X3QgZXZ0Y2huLCB1bnNpZ25lZCBpbnQgaXJxKQ0KPiAg
IAkJICogdGhyZWFkIHdhcyBmYXN0ZXIgaW5zZXJ0aW5nIGl0LCB3ZSBjYW4gZHJvcCBvdXJz
Lg0KPiAgIAkJICovDQo+ICAgCQlpZiAoY21weGNoZygmZXZ0Y2huX3RvX2lycVtyb3ddLCBO
VUxMLCBldnRjaG5fcm93KSAhPSBOVUxMKQ0KPiAtCQkJZnJlZV9wYWdlKCh1bnNpZ25lZCBs
b25nKSBldnRjaG5fcm93KTsNCj4gKwkJCWtmcmVlKGV2dGNobl9yb3cpOw0KPiAgIAl9DQo+
ICAgDQo+ICAgCVdSSVRFX09OQ0UoZXZ0Y2huX3RvX2lycVtyb3ddW2NvbF0sIGlycSk7DQo+
IA0KPiAtLS0NCj4gYmFzZS1jb21taXQ6IDY2MjhlN2Q0YzZiMjVjOGQxOGYxMzQ1ZTNhMjBk
MjE4MjlhYWU3ZTQNCj4gY2hhbmdlLWlkOiAyMDI2MDYyNC1iNC14ZW4tYTFjZDYyOWNlOWY0
DQo+IA0KPiAtLQ0KPiBTaW5jZXJlbHkgeW91cnMsDQo+IE1pa2UuDQoNCg==

--------------9CjsJxfyxMmK8BT64s75qaM0--

--------------wXW5pNoOVuHMY5I23DbFQuaD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmrxe+4FAwAAAAAACgkQsN6d1ii/Ey9J
cwf+L3XaMzorCG1a1NqCToQpyu0zZH4Y8kmNNW0/rOxHQHH3N6z1NjBS/4OA3dFxz/HgVZJG9fjN
VpLu3NGawgxhx0kswckZeP0mL1qsTAJNqCJt2iR9xPBSQIhvWz2dTObySLv7i2AzzK+7Ker8V/A3
l9M7wG9YjYC9c0fsPRcqtYFECiH8KZL47sOCGX+2mS5bn1lJG7U9/C1ODW3hmiTns3rdiYFg8TxX
NFVkoo/VFf1nIjJtr4IVJsVNhyOsfTRRbbiy4eyb8RpYC5mCNK2t9k1m5Q/EN8ZvRlsG+EcptY/7
VqBH+RbDz8HR65Q9mlfkxWSs8/m1rpk6XBRjjX7n+A==
=sx3s
-----END PGP SIGNATURE-----

--------------wXW5pNoOVuHMY5I23DbFQuaD--

