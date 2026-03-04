Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A892CEF8FE5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C451B6B00BA; Wed,  4 Mar 2026 08:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2DA6B00BB; Wed,  4 Mar 2026 08:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72246B00BC; Wed,  4 Mar 2026 08:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F01C6B00BA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:54:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 335BB1605F0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:54:28 +0000 (UTC)
X-FDA: 84508525416.29.C1F64DB
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB5A74000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:54:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b="U/2up/sa";
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf17.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772632466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHSahOhec/gGjGF+nB8hfIQZQQElJINWnaP5bQGjplI=;
	b=CQ8R+fIJ0uyTAc1/q4SFooSjdCzM8lSFMWQ0VrlA3gtvEX4YzqU/0YSYbFghGOoRe0MRJ+
	W2WAX7oPopbXetz/q+nWWmgyR47AQY4mZ3wx7OUPWRSgDrTgW4+Lbb34IhleN2ZGgrrGDq
	NdqMzixWsrtOiHPD8BhTKrq/G3k1IV4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b="U/2up/sa";
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf17.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=spasswolf@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772632466; a=rsa-sha256;
	cv=none;
	b=E1M5J47bxcJc2GPBVYNY3Ol5bzxg3V5LmlQIUy5mWR3tsCYjSZKK0NEm24164rkz0q/xrk
	dCPyuSL4tKGpIZiSiiB8p5/RZdsfRPLg6JZweiFRowr3RwoITeNX3PVSyqtSABRUmzV8SZ
	PiJp1xF+ZtmjNWIcV9F8CxZTasLjN9I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1772632464; x=1773237264; i=spasswolf@web.de;
	bh=QHSahOhec/gGjGF+nB8hfIQZQQElJINWnaP5bQGjplI=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=U/2up/saznQ/dNhFfhzYf3HcJo7xkpNxaDCj5bPCpJiRnyIOjBXz3Lp390+8VV7R
	 ubZi0Xb1nCVRQQY/umgzwn0XSvSkvqMiQBjMo07iDzHb87EcFGx15A0CG3FMlAgyc
	 rDYYj8BbFqPNFfEGkPtbJNfWKmqohHvX8qEPgpc1NCEFfk3Rb9z7988iMvrXGXtLy
	 o6leMoYdTt9FvEWckbh4lpkzuglBwqxZ+/Tf8Ub3I+pwMtuTe7PTR8MH2YeYRFbs1
	 PUCcgceyl+ezdTN8lVbZXlDVpRV4VjhEdBLtusdhoeQrehRy6KYbEkzQGrbZgmAYK
	 fmzZiPE8SMQk4KMTcg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MV2Oi-1w8H5l2OL0-00WxsJ; Wed, 04
 Mar 2026 14:54:23 +0100
From: Bert Karwatzki <spasswolf@web.de>
To: linux-kernel@vger.kernel.org
Cc: Bert Karwatzki <spasswolf@web.de>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: rtmutex deadlock and memory corruption when running gcc testsuite in next-20260303
Date: Wed,  4 Mar 2026 14:54:18 +0100
Message-ID: <20260304135419.3182-1-spasswolf@web.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260303180434.6ecac68b@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1apTthLwA6e8KGmdNksPxns51es4WxfJOtCiIwckyvkOrFgnKpj
 ajHy2jU9PedCYtSLxamEaZFicTi7CKLMef2z55drBOWSkCMlAngyOS+587tuXtRWHi5CXgQ
 feBss7xRChmVkBDqjS9NatNCe/qVqYkeHwIjh9Wdperushi++atEHz7vA18h8ZJrupPjusO
 7WiUtm6nQO+mj7X4OHZiQ==
UI-OutboundReport: notjunk:1;M01:P0:2H5lzuiJosE=;Rja5EipI93zJYKmxmsKSmHETiyg
 O+9/xc+UAx6FMVVOtlHxMgwksUl9B6xp3EccpRR36IZhLsz5x0eVU62qCzjkEXkbB3/6CerSs
 u3G7p4KFPGsIdqY4drSs42N+u5OL4zAHi03WfvoO9rDEUvs71qzQJbOIXGZgR5CFCyq0c9VtU
 fFVTqiYto+7jdWJuEQAQ7f8blKxJfSr2eoOWEHaChZho+BsMPG9fa0w3vhAKZbJ3X8pQ9iiL9
 DJ1p6WMe1KnzzjhIV7k0eXBjm3bVL3QplOdo7KPySuwOssKdNT5y4VwGX45re7sPGDYAIH2/r
 mInfeaJdzYyj/GmXiJAAbhxZgbb+Ocq1UujT8ZTg4rMaXUjOzAQJtCtd/RMN27TSuk8CrIxzo
 lNHJUBM+LDhNxxcwTLcAsf0Y0A0qxKZYET1LRgSzmqGuORyStWO7KVEO4bhJZAOhQRhzqp5eY
 VciR/tvKcMFAR9DDE7l9NX7p7gzjBZMgIVQbIf0wjwj8CMQw4eI8YuRYmP+siIL+0KAp06CEV
 95vfq9O5wvDXpcJkE8vRKRmCQRpMdb0nEYf++F/r54nwzE0RZvU+0ANJrB19wsXsan2iRWu0a
 0Cg/OKvqH8CzaVlVS0qB7QYVjuGDxz2GDs9zpz6BecB279t+7oMe7rinQ9ppN46Na5Ji1Yybn
 YQxIkI34fYOf24Ve0eIQHC4BCMUU8Rw+34JOuANqFcsCGMG0HZa9MHP9NfxDbxiQD0BUXiwzb
 UW0MCkewrL0ydAtx+ipPflWsWKD9q19yMWge3REG7c2l+8ZTqnI998Nam3BxrSUf/cZWl12gE
 dM+ke8rUP5z1xxp2mt+ywUKjN/ReUbJ89UU3c1AODLKcrm82pcYjRjXDA+auM8j2UXKMJqYQQ
 zVgWh/INBkCuuRYpxwd1dhC6VTRxRiXM9sU2aTFqbNLXJVKNkORAMTtS57kyb193jyyCCyLVJ
 esp1KsfWewatvod2PUIZGFAoD6/Y04AsDBSYfQI+sRkEtgnRw76IaK7vAWrDkCGt1EB/uUhtk
 En0NNTFurjHR6a/DUm2b3rluM/9gUuZAe+z4Y2pt/kH9sFL3HxnjckaL9+rN2ksu/Ah0FGwSx
 412EreluIKosUBkWi9116/HnYU0faG2KEEqchSO624Z/50ZG1krIiO8zXATN8rJAtBKXy5CzY
 cy5aovpqa6sjKg998ryAUGuQO92fBWH03A100ZPBKBzQfwWr4Yv91JF27j/to2mhnsuWvueTD
 ByU/a/eCU8SalWDHFUxWyoXcGQq5mzmnoUw26sC9TpzCXJGq7ae73URa9dJyv9Vixpn2D8cZP
 KIr2jXl/79BWKm/LPg8tGoEssob47SEoe8RXhFVXp6fHjtReeovmUvTjz6Gfqk5xJAtFgF7Hl
 W7az9dOMfbKyDoeL32XdIRkhPEQTw5amnQlUDQuhOzxsR5gW+j080tzi5aNFYm0lLa6UTfM+X
 DKOTw5sAu02PvLiGPujbuQu3PPg08NBlWJzTC25h6k5K6i0Tfr8d2BZxf+Ns3VXv1jcSII5or
 a8owdi1kEfc5ILmbl+DdPOHGig22bdwka2uepbdgDiEil41M4qJK3MwX3xpYetf9tsSNFdMLO
 Mp5Eon7udrxwdCgiCwWXVkW3jtsNE0x1op0DQGdLweQNG3VZJrDDOgZkCDrjNUAaqMzaWa0/9
 ViIKpOgiVKnZ7D2LKcn4G5aa8ds04Ysv8zYBehDVzQMzar5F4FXYF4zRvn9G5I+Jpp0F2NTg7
 swwRj9Kf6CWLupSEAPsPb2BUMVlX+LtXvubXxQJ3YOURJjCya3mUZxDTIXbBlCmPnpbLM2XxT
 k0qCGT3G21XbRVSn+qjEE4m4KfpYkr6zTmzEXC86lpHKWfVZyC+weg9IOmDLbrp2te0VhEdkR
 p2NtWONyIUWsIVy4w3C/pE+rJyU8mJFgfc6F1UXhnNkfCpU8zB6+Qp5a8zSG+vjn+ezKNkiR0
 x08TunL7J9oQrxk6u6V6+VvTMlAytu9HP6bLMNNxGdRMiMX+2IyqERzilwr93dGPFqXPGNTNb
 esjmKpLEXuB9sbLYTKiOuorNYKdVqBZIjgVzoC7Mo0hUoqZ21fY7yF1Pxu+Y0wI50TcZ+9bxh
 /Z2ijfU2AylWEib7pLXVdpUKGQgNF9ElozxZYNCQCB4ztYS1Z7hzCSSEq9f5Pr9yZmypLKjYO
 jNa012Pe2XyzY4TZxpnr7nTokfB5zQxh+hXdUE+m/b18/9MmrHuI7qd/MwUChY758Ucql6EdB
 nS5dLwTowAeUIpepi2kCLj20F5AxGjnrWE5/fIZM2AEMYweV79H2TdDH/SnHJz/nz7XihYQcz
 UXRWQMiyHcifr6FEDBsFxcWG8tnDM72LPYv+DrkXe/ggx8L09doBbnxlb3VUf5zrHF8bzR2g9
 faw1iKxAjEagj35Wj9VUTwYf5Uz3hMjMFELfp8zEcqbnAE24S4mRAKnlmQxFBuKQPju2NZOVQ
 9rDRhTaSp5z52CHHm9UcaY97VyVM18/+sQLQItozYrF00sFyKmIePp+V43abYVELAcR8DOR7N
 im4LXMW0YFDAlTukpM/Qhq8soIID414U3QP0QAAWER/TDYwPWeh09lU3ZpZ8dCa2YGB5uEltK
 Vz3r8IBvEz86ncVvFLS14HU4zUVASl2Ob/xAfrSfphewU9ncheQ7dhPZxpaQxW5xZsKLw1zzg
 98suaNvgaLY4kC5o/2g5KrpaodnTN6opaBBZeeGqZ20gg8byNuTMFNojPvxo+8HcsMG2sptjV
 AiAaACdenUMJilsbG4vOHG1tMKKKDIJg8CBiXTABCSZEb+MpPsHNMAgy/d9gZF/JeJy3+SOG8
 09cEzlrY5QW/5BjgiuGg6e8HrildMakxPWzvMPLlnYfOABlPjQCwkuUZbaaojRzHrbiqYTy8r
 aKOMQcGmimism8hLijw5l9xSsE7ipAPpooEoEgSjnJyJaBkdeYE+ohjU/E7LyrEVH7W5tUpg2
 Vs5URsicsupm1OL/YBlr3YNuJF8aFXjOghOpcncqJhYxsNI5IIVYaT/d6E/7qYyqKAKeBW1AZ
 QagMmX5YIJgQC9ps51pkV2uz2EUlpft/yyY7zW+QSM0f74ol3KuKnqgVsCbxlUKZd+2C+qQaw
 ECAHHTmJqIqIFAgrENdUSDX0lVFyzpcj9SxO4bCY7ogHuJnXQcoXzf6gARoGfHtL4HPzOT8Vo
 d9TbPVifCzUou/wzQsg5XKf2lNQ3FR7aSCEGuOpRitidSPv2nTX1dF4PL7rKgRK4PeoVzEVsD
 ONdcjEfbArSpwRVDVrcJeua2m/t7Sh7cg8baSdqZK1k5xVtFWIqJ0hyZfA65OSwUX36yVlKv7
 8N1Lkn+mPH0VL0/xgz7v782j83vTqZrbEUxNhhjppWlEbE5L8gN2/9xIugiBJ5yB1szNPcqfy
 b9mXQQqmoBLC531g1SLDulgZpks/w7XaNZHCMmIOpX4yix9k6WVTNYQGQRhugTNL5ifHFnEw2
 v1XQGQkUuowFt0Qrru4/zdbaEkuS+948cy5EuSe+hMs90vZk1LyGS3SoBSiOljUnxDi5LeacH
 Olo7JQe8cQBCKVXtz+Tj28BoyxsynCNsZ4HVpfDKj3/2bmmTBUrTbWU4BKIrPVXnNIpR/HJLz
 UAlHKGpo86xxb+cMIcyfjnw/1/uZ6z2r5VEkHxXZoTV92GOg9EAuY1kk7Aw3YHyo6NmQIBang
 U0cfsnIOoaQs/+/FUlOitReQ0ubYZGyrk/biMUjUFcNGRQk9Zts8dSrCdQkSFUpNpRSSP77or
 yJKr4Ail6BhuEXizk74jQTdB1rC4vj0vju+237Jst6tybkSTslhTuzi9vmq2H+/Ua1DHmDrW3
 ssYn9YhW8sVZHoGZCxdCZ+ZiNWGkeXMzjw1Bl9vCFAQBLFsg40DGBfPDezecOGVvmS7DnSz4t
 zhWfKuhTHD540QWZAzWO/BPENdGGnExwlFZcMf9XN7fQbmMT1nuE4Q3bRtpcdcSvl48v6ghs/
 j/7CZSimj2sjF2f3axbTIxm+TQ4+3FWZH4eCdDuDKg6SCuUgCbFmw5fY1QL3lmBGIcrTfFflD
 F/oTtpZMrt3PTgTxUsDiucdT4phw5osN5L45fLQPu2oi6AvlCYlwvYXR2388iyahLjLV717id
 +PXq2TClMTGa8AICHEnMyhjMmu8ADVE2ocDUzqKGNjf3m3+pp0BMXvrXyLacgKevzMLIxRpUD
 MpJjij2a2hHXJD1iOeqWFM/cL6fsQdQc5N9oj80As0+2sXmGuw2DDOqw+utHguqV70X2p3w1G
 dYDGaO60uPTgerJCG8toOrKSTXHn53HAqVCvBPaukGgbcWj9wAhgQGLF5wqn6bE+Z9HeU2/qj
 /o/CFyv43XBHx3hGtwEOnaqPr91PguG9xC+JjBQoX1f13N7zDZHT3u71yk25Ix7PQMUfEpWMq
 EI7o5tJpTn1+GDCwnmEk7ukQnNA9RKvW5sZ4p/utbsknmFmY3OhyrsLYDwQjv/0OtwckqymjH
 m+TRkEEqfo+miBTdnpXfpsQsaSjAYG1yF1u19drlgQFb1IYHgtQpmlVdSQSABY0PtqCYllDzv
 S3ESE0uiK/oIzwPy5VJv5gR7H96ydGW5cvdJtXlgySRuscYQaSfkXzaqKsl/g3J0B6VfOGCMx
 e8urYze3JHWc9PNsGFvuYJ60liPEDYY6H95c7V755+uWDH+ct6h9n/k+PCVBM1J2tkSItJz4f
 HSQ4/QXkx+DHQKpftNK7OXpriGOYe7/VfOvhuWL/rxOe4wkkZraAAPsnjefla/CSsZxTEhfuq
 OTiXiVpL4BfWJlb/EJnKaqmMI5rkNOz9Alh5XBig693a4IAIc0AAM4juakCAxNdSF7/Jq5IbN
 U0CX5+2b1IE0v4RDNUtdO3cu/zm8czKjQ/rPitLWsoxqvoGi0Q0D/jNfv/FyJdqgKtuYKhC2V
 BNp9xEVJMr54yXenqThrDa1ell2AgeQ8krzXcxZVSL0or+SQXpMrvdxS+d59cKhmuZ7OptOPM
 xfV+b0qLUX4WuDd5IcdymvPxVWF6UDLa/iBKxLcr1e+H3VrBmLOe0VQB7PscuXKfks7XbzHUe
 qMzZ0wnGUp8DHFyR0eAkH3k6WGQaKhQ65GQiiLVQ8dqrYtuovvLAmWAmAbH8tRY4dCQEKPLU/
 QY/d5ckVok3b+su7l5AzW1EO7jljY64QV85uLRK6GiDMWAEnzXFwCuPzaZj9Y0W3wwD7nDU3Q
 tP/EvCiwRrL7qf/PU3QpD0uTjxT5CkJF1xAWbM3sjhmKrnScqJ4NkADOSGu7yCsdjF6JNj6SD
 4SuSzvUt3VIfyiamjo/MmsFMi/ujS9Il/e5wTyrZ0xwavyZIRyihZQyYOcZnsoo=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB5A74000A
X-Stat-Signature: q7577phpmrxkqwwjaopnspanrthrr38x
X-Rspam-User: 
X-HE-Tag: 1772632465-352467
X-HE-Meta: U2FsdGVkX19keB4jq/JfbWYBvtw40/owIdHHxRk0JWroCy2I4ostoRSPsZJtqpP8iMp1cQI0ABFltQZDZWiAHjjYQQD0HaXf4VloX6mQU9U8w9fH4Rt9hmLrIxvGhK0p53CuGZIcTOHZ7dBcGv9Y9r7F8aA3h8LOd5l6VjYQ+YkRx5dgxiPmu7qLqtj3RNaZFyfzwev5GaRaIzfm+V85XHjbSsrd29T6bJEsa4Oj5r8bgntCHdaEsggqOK416inwIz1DJrUBV1rItJrT70AjL4b4WnZm2F5QT8nLEOuIzGms+sj7MOau5dfYIkaKcyBfNFsQywsNfhmOXE05t3DwEztOYPELSXC4u+xOL/6loJbUPmwDaRGqxPhcfKm4mLWHbeXxvvzp3BJIdoq5CKdJLVUsXSdCXp7lt/GNv3V9J5XWBDwIg2fCmh0eRAlFysX4GHxJ4OMprCSdgbxokzbQi4+6hLnXCg251PCTekTtGTHMsvo/7k/n9yk4DRKsn1TX7jV6XhflUXLzr5q60cwgZIWWz8pm/YIkHfsMRNzRmivAthI+QYEC5S0Sm6FmTYcEWlR52eupWBDSeaEziw3W0MGNglD35R71b6Qcf8sV9bz6zk1JlyRePwwgxxu4PkmpKIki/GKi640Jyc7L6MuppgfYNVE6ukwuiYgWbPvuUg+5jaLaMn//eiTElbxNU3no6xyafHoWvDen8DNlAW3QCP+ZTkJg6a6n/ZAQd81qXQ2IkO8DwAB3RjF2NGG2m8gNqdfGa52yo4jP9Dg/YMyE3Qz9SOD+uGx6pkDpqYHtfGTJ0MihPY/WbKSFqpcx3qTxM+Ua1o8ZISXqS17i9XUcqfKiIjwQV437tGmix+otRJe5Gjz1zwzCzulKGdbPvN1UTU+RvS/+OtFimeXZuF7fA8A0OozIw/qLmVZqDMBAAW3kx9Z2wuKla5K+OiDBf3pwlK11LLFH8jBlIjvEgNC
 HY0Iv6QN
 Ee5oQ4onwlG7f54yq3ndaHprOeE08XYHQmNJNHrBkluWoLcDw1U190/v31EswZLv05u7+lTWzVK4YtgkTN19F1lazw2Bwu2bPo0kVs6rBVakopZE6PYV4Oahc/zILTxfgUWRo2jlb5bZe9nL39+iYb6i4+0nlSW2Zi6shSRY3hc+9gUMhDALF8fX0w37IqGK393Nx+o+5bK7d0oWkNCw4f6Xfidxy2YXFG6GF1hSMImUIxsIC0XESZRVe09g5Bw8ifyukqueklJhFd2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've got no results on the bisection, yet, and this bug is not 100% reprodu=
cible:

I did 3 test runs with the gcc-14 source code from debian and:
$ time dpkg-buildpackage --no-sign -b

On the first run I got no error.
On the second run this smaller error happended, but the rest of the system
was not impacted:
2026-03-04T12:23:26.176512+01:00 homer kernel: [T2845420] BUG: unable to ha=
ndle page fault for address: ffff90db1d84fa18
2026-03-04T12:23:26.176527+01:00 homer kernel: [T2845420] #PF: supervisor r=
ead access in kernel mode
2026-03-04T12:23:26.176529+01:00 homer kernel: [T2845420] #PF: error_code(0=
x0000) - not-present page
2026-03-04T12:23:26.176529+01:00 homer kernel: [T2845420] PGD b82001067 P4D=
 b82001067 PUD 0=20
2026-03-04T12:23:26.176530+01:00 homer kernel: [T2845420] Oops: Oops: 0000 =
[#1] SMP NOPTI
2026-03-04T12:23:26.176530+01:00 homer kernel: [T2845420] CPU: 26 UID: 1000=
 PID: 2845420 Comm: xgcc Not tainted 7.0.0-rc2-next-20260303-master #367 PR=
EEMPT_RT=20
2026-03-04T12:23:26.176530+01:00 homer kernel: [T2845420] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T12:23:26.176531+01:00 homer kernel: [T2845420] RIP: 0010:kmem_ca=
che_alloc_noprof+0xc4/0x330
2026-03-04T12:23:26.176531+01:00 homer kernel: [T2845420] Code: 6b 00 85 c0=
 0f 84 57 01 00 00 65 48 8b 3d 0c a1 26 01 48 8b 33 48 01 fe 48 8b 56 20 8b=
 42 18 85 c0 0f 84 91 01 00 00 8d 48 ff <4c> 8b 6c ca 20 89 4a 18 48 03 3b =
e8 dc 82 6b 00 41 0f b7 84 24 70
2026-03-04T12:23:26.176531+01:00 homer kernel: [T2845420] RSP: 0018:ffffb9f=
c29c6fa28 EFLAGS: 00010282
2026-03-04T12:23:26.176532+01:00 homer kernel: [T2845420] RAX: 000000000000=
0000 RBX: ffff90c640079a00 RCX: 00000000ffffffff
2026-03-04T12:23:26.176635+01:00 homer kernel: [T2845420] RDX: ffff90d31d84=
fa00 RSI: ffff90c6400b3080 RDI: ffff90d5cc361000
2026-03-04T12:23:26.176637+01:00 homer kernel: [T2845420] RBP: 000000000000=
0cc0 R08: fffff667849db200 R09: ffff90c7acfc8000
2026-03-04T12:23:26.176638+01:00 homer kernel: [T2845420] R10: ffff90c64316=
e900 R11: 0000000800200018 R12: ffff90c7acfc8000
2026-03-04T12:23:26.176638+01:00 homer kernel: [T2845420] R13: 000000000000=
2000 R14: 0000000000000100 R15: 00007fe32f880000
2026-03-04T12:23:26.176638+01:00 homer kernel: [T2845420] FS:  000000000000=
0000(0000) GS:ffff90d5cc361000(0000) knlGS:0000000000000000
2026-03-04T12:23:26.176639+01:00 homer kernel: [T2845420] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T12:23:26.176639+01:00 homer kernel: [T2845420] CR2: ffff90db1d84=
fa18 CR3: 00000002f2782000 CR4: 0000000000f50ef0
2026-03-04T12:23:26.176639+01:00 homer kernel: [T2845420] PKRU: 55555554
2026-03-04T12:23:26.176640+01:00 homer kernel: [T2845420] Call Trace:
2026-03-04T12:23:26.176640+01:00 homer kernel: [T2845420]  <TASK>
2026-03-04T12:23:26.176640+01:00 homer kernel: [T2845420]  mas_preallocate+=
0x406/0x450
2026-03-04T12:23:26.176641+01:00 homer kernel: [T2845420]  vma_link+0x5d/0x=
180
2026-03-04T12:23:26.176641+01:00 homer kernel: [T2845420]  insert_vm_struct=
+0x41/0xa0
2026-03-04T12:23:26.176641+01:00 homer kernel: [T2845420]  _install_special=
_mapping+0x7d/0x140
2026-03-04T12:23:26.176642+01:00 homer kernel: [T2845420]  map_vdso+0x93/0x=
190
2026-03-04T12:23:26.176642+01:00 homer kernel: [T2845420]  load_elf_binary+=
0xdb4/0x1880
2026-03-04T12:23:26.176642+01:00 homer kernel: [T2845420]  ? __kernel_read+=
0x1a1/0x2a0
2026-03-04T12:23:26.176642+01:00 homer kernel: [T2845420]  ? rt_read_lock+0=
x40/0x130
2026-03-04T12:23:26.176643+01:00 homer kernel: [T2845420]  bprm_execve+0x27=
c/0x4a0
2026-03-04T12:23:26.176643+01:00 homer kernel: [T2845420]  do_execveat_comm=
on.isra.0+0x157/0x170
2026-03-04T12:23:26.176643+01:00 homer kernel: [T2845420]  __x64_sys_execve=
+0x38/0x50
2026-03-04T12:23:26.176643+01:00 homer kernel: [T2845420]  do_syscall_64+0x=
11b/0x8c0
2026-03-04T12:23:26.176644+01:00 homer kernel: [T2845420]  ? do_fault+0x37e=
/0x640
2026-03-04T12:23:26.176644+01:00 homer kernel: [T2845420]  ? __handle_mm_fa=
ult+0x2c6/0x3a0
2026-03-04T12:23:26.176644+01:00 homer kernel: [T2845420]  ? count_memcg_ev=
ents+0x5e/0xf0
2026-03-04T12:23:26.176644+01:00 homer kernel: [T2845420]  ? handle_mm_faul=
t+0x1b9/0x2c0
2026-03-04T12:23:26.176644+01:00 homer kernel: [T2845420]  ? do_user_addr_f=
ault+0x203/0x640
2026-03-04T12:23:26.176645+01:00 homer kernel: [T2845420]  entry_SYSCALL_64=
_after_hwframe+0x55/0x5d
2026-03-04T12:23:26.176645+01:00 homer kernel: [T2845420] RIP: 0033:0x7f9fb=
7339dd7
2026-03-04T12:23:26.176645+01:00 homer kernel: [T2845420] Code: Unable to a=
ccess opcode bytes at 0x7f9fb7339dad.
2026-03-04T12:23:26.176646+01:00 homer kernel: [T2845420] RSP: 002b:00007f9=
fb7476dd8 EFLAGS: 00000206 ORIG_RAX: 000000000000003b
2026-03-04T12:23:26.176646+01:00 homer kernel: [T2845420] RAX: ffffffffffff=
ffda RBX: 00007ffdfef7fb22 RCX: 00007f9fb7339dd7
2026-03-04T12:23:26.176646+01:00 homer kernel: [T2845420] RDX: 00007ffdfef7=
7e60 RSI: 00007ffdfef777f0 RDI: 00007ffdfef7fb22
2026-03-04T12:23:26.176646+01:00 homer kernel: [T2845420] RBP: 00007f9fb747=
6e50 R08: 00007ffdfef77310 R09: 0000000000000000
2026-03-04T12:23:26.176647+01:00 homer kernel: [T2845420] R10: 000000000000=
0008 R11: 0000000000000206 R12: 00007ffdfef777f0
2026-03-04T12:23:26.176647+01:00 homer kernel: [T2845420] R13: 00007ffdfef7=
7e60 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T12:23:26.176647+01:00 homer kernel: [T2845420]  </TASK>
2026-03-04T12:23:26.176648+01:00 homer kernel: [T2845420] Modules linked in=
: nct6775 nct6775_core hwmon_vid rfcomm bnep ccm snd_seq_dummy snd_hrtimer =
snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm btmtk blueto=
oth mt7925e mt7925_common mt792x_lib ecdh_generic mt76_connac_lib ecc mt76 =
snd_hda_codec_atihdmi snd_usb_audio intel_rapl_msr joydev snd_hda_codec_hdm=
i snd_usbmidi_lib mac80211 snd_ump snd_rawmidi snd_seq_device intel_rapl_co=
mmon snd_hda_intel wmi_bmof rapl snd_hda_codec pcspkr libarc4 snd_hda_core =
spd5118 regmap_i2c snd_intel_dspcfg snd_hwdep snd_pcm cfg80211 snd_timer sn=
d soundcore k10temp rfkill ccp evdev configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper xhci_pci xhci_hcd dr=
m_kms_helper ahci libahci drm libata usbcore nvme scsi_mod nvme_core igc ce=
c i2c_piix4 scsi_common usb_common nvme_keyring i2c_smbus crc16 nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T12:23:26.176648+01:00 homer kernel: [T2845420]  gpio_generic
2026-03-04T12:23:26.176648+01:00 homer kernel: [T2845420] CR2: ffff90db1d84=
fa18
2026-03-04T12:23:26.176649+01:00 homer kernel: [T2845420] ---[ end trace 00=
00000000000000 ]---
2026-03-04T12:23:26.176649+01:00 homer kernel: [T2845420] RIP: 0010:kmem_ca=
che_alloc_noprof+0xc4/0x330
2026-03-04T12:23:26.176649+01:00 homer kernel: [T2845420] Code: 6b 00 85 c0=
 0f 84 57 01 00 00 65 48 8b 3d 0c a1 26 01 48 8b 33 48 01 fe 48 8b 56 20 8b=
 42 18 85 c0 0f 84 91 01 00 00 8d 48 ff <4c> 8b 6c ca 20 89 4a 18 48 03 3b =
e8 dc 82 6b 00 41 0f b7 84 24 70
2026-03-04T12:23:26.176650+01:00 homer kernel: [T2845420] RSP: 0018:ffffb9f=
c29c6fa28 EFLAGS: 00010282
2026-03-04T12:23:26.176650+01:00 homer kernel: [T2845420] RAX: 000000000000=
0000 RBX: ffff90c640079a00 RCX: 00000000ffffffff
2026-03-04T12:23:26.176650+01:00 homer kernel: [T2845420] RDX: ffff90d31d84=
fa00 RSI: ffff90c6400b3080 RDI: ffff90d5cc361000
2026-03-04T12:23:26.176650+01:00 homer kernel: [T2845420] RBP: 000000000000=
0cc0 R08: fffff667849db200 R09: ffff90c7acfc8000
2026-03-04T12:23:26.176650+01:00 homer kernel: [T2845420] R10: ffff90c64316=
e900 R11: 0000000800200018 R12: ffff90c7acfc8000
2026-03-04T12:23:26.176651+01:00 homer kernel: [T2845420] R13: 000000000000=
2000 R14: 0000000000000100 R15: 00007fe32f880000
2026-03-04T12:23:26.176651+01:00 homer kernel: [T2845420] FS:  000000000000=
0000(0000) GS:ffff90d5cc361000(0000) knlGS:0000000000000000
2026-03-04T12:23:26.176651+01:00 homer kernel: [T2845420] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T12:23:26.176651+01:00 homer kernel: [T2845420] CR2: 00007f9fb733=
9dad CR3: 00000002f2782000 CR4: 0000000000f50ef0
2026-03-04T12:23:26.176651+01:00 homer kernel: [T2845420] PKRU: 55555554
2026-03-04T12:23:26.176652+01:00 homer kernel: [T2845420] note: xgcc[284542=
0] exited with irqs disabled
2026-03-04T12:23:26.176659+01:00 homer kernel: [T2845420] ------------[ cut=
 here ]------------
2026-03-04T12:23:26.176659+01:00 homer kernel: [T2845420] rtmutex deadlock =
detected
2026-03-04T12:23:26.176659+01:00 homer kernel: [T2845420] WARNING: kernel/l=
ocking/rtmutex.c:1674 at __rt_mutex_slowlock_locked.constprop.0+0x835/0x9b0=
, CPU#9: xgcc/2845420
2026-03-04T12:23:26.176659+01:00 homer kernel: [T2845420] Modules linked in=
: nct6775 nct6775_core hwmon_vid rfcomm bnep ccm snd_seq_dummy snd_hrtimer =
snd_seq nls_ascii nls_cp437 vfat fat btusb btrtl btintel btbcm btmtk blueto=
oth mt7925e mt7925_common mt792x_lib ecdh_generic mt76_connac_lib ecc mt76 =
snd_hda_codec_atihdmi snd_usb_audio intel_rapl_msr joydev snd_hda_codec_hdm=
i snd_usbmidi_lib mac80211 snd_ump snd_rawmidi snd_seq_device intel_rapl_co=
mmon snd_hda_intel wmi_bmof rapl snd_hda_codec pcspkr libarc4 snd_hda_core =
spd5118 regmap_i2c snd_intel_dspcfg snd_hwdep snd_pcm cfg80211 snd_timer sn=
d soundcore k10temp rfkill ccp evdev configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper xhci_pci xhci_hcd dr=
m_kms_helper ahci libahci drm libata usbcore nvme scsi_mod nvme_core igc ce=
c i2c_piix4 scsi_common usb_common nvme_keyring i2c_smbus crc16 nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T12:23:26.176660+01:00 homer kernel: [T2845420]  gpio_generic
2026-03-04T12:23:26.176660+01:00 homer kernel: [T2845420] CPU: 9 UID: 1000 =
PID: 2845420 Comm: xgcc Tainted: G      D             7.0.0-rc2-next-202603=
03-master #367 PREEMPT_RT=20
2026-03-04T12:23:26.176660+01:00 homer kernel: [T2845420] Tainted: [D]=3DDIE
2026-03-04T12:23:26.176661+01:00 homer kernel: [T2845420] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T12:23:26.176661+01:00 homer kernel: [T2845420] RIP: 0010:__rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0
2026-03-04T12:23:26.176662+01:00 homer kernel: [T2845420] Code: 00 48 89 ef=
 e8 fc 67 87 00 c7 44 24 14 fc ff ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89=
 ef e8 b2 66 87 00 48 8d 3d 2b 58 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 =
e8 87 43 18 e8 e7 6a fd ff eb f4
2026-03-04T12:23:26.176662+01:00 homer kernel: [T2845420] RSP: 0018:ffffb9f=
c29c6fd18 EFLAGS: 00010286
2026-03-04T12:23:26.176665+01:00 homer kernel: [T2845420] RAX: 000000000000=
0000 RBX: ffff90c7acfc8000 RCX: ffff90c7acfc8001
2026-03-04T12:23:26.176665+01:00 homer kernel: [T2845420] RDX: 000000000000=
0001 RSI: ffff90c7acfc8000 RDI: ffffffffb1236620
2026-03-04T12:23:26.176665+01:00 homer kernel: [T2845420] RBP: ffff90c80b18=
3938 R08: 0000000000000000 R09: ffff90d5bdcf6f90
2026-03-04T12:23:26.176665+01:00 homer kernel: [T2845420] R10: ffff90d5bdd2=
6fe8 R11: 0000000000000003 R12: ffffb9fc29c6fd40
2026-03-04T12:23:26.176666+01:00 homer kernel: [T2845420] R13: ffff90c7acfc=
8001 R14: ffff90c7acfc8c40 R15: 00000000ffffffdd
2026-03-04T12:23:26.176666+01:00 homer kernel: [T2845420] FS:  000000000000=
0000(0000) GS:ffff90d5cbf21000(0000) knlGS:0000000000000000
2026-03-04T12:23:26.176666+01:00 homer kernel: [T2845420] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T12:23:26.176666+01:00 homer kernel: [T2845420] CR2: 00007fa197ff=
9af8 CR3: 00000002f2782000 CR4: 0000000000f50ef0
2026-03-04T12:23:26.176666+01:00 homer kernel: [T2845420] PKRU: 55555554
2026-03-04T12:23:26.176667+01:00 homer kernel: [T2845420] Call Trace:
2026-03-04T12:23:26.176668+01:00 homer kernel: [T2845420]  <TASK>
2026-03-04T12:23:26.177327+01:00 homer kernel: [T2845420]  ? psi_task_switc=
h+0x105/0x280
2026-03-04T12:23:26.177332+01:00 homer kernel: [T2845420]  ? finish_task_sw=
itch.isra.0+0xc3/0x370
2026-03-04T12:23:26.177333+01:00 homer kernel: [T2845420]  __rwbase_read_lo=
ck+0x4a/0xd0
2026-03-04T12:23:26.177333+01:00 homer kernel: [T2845420]  acct_collect+0x1=
57/0x1c0
2026-03-04T12:23:26.177333+01:00 homer kernel: [T2845420]  do_exit+0x1c2/0x=
a30
2026-03-04T12:23:26.177334+01:00 homer kernel: [T2845420]  make_task_dead+0=
x94/0xa0
2026-03-04T12:23:26.177334+01:00 homer kernel: [T2845420]  rewind_stack_and=
_make_dead+0x16/0x20
2026-03-04T12:23:26.177334+01:00 homer kernel: [T2845420] RIP: 0033:0x7f9fb=
7339dd7
2026-03-04T12:23:26.177335+01:00 homer kernel: [T2845420] Code: Unable to a=
ccess opcode bytes at 0x7f9fb7339dad.
2026-03-04T12:23:26.177335+01:00 homer kernel: [T2845420] RSP: 002b:00007f9=
fb7476dd8 EFLAGS: 00000206 ORIG_RAX: 000000000000003b
2026-03-04T12:23:26.177335+01:00 homer kernel: [T2845420] RAX: ffffffffffff=
ffda RBX: 00007ffdfef7fb22 RCX: 00007f9fb7339dd7
2026-03-04T12:23:26.177335+01:00 homer kernel: [T2845420] RDX: 00007ffdfef7=
7e60 RSI: 00007ffdfef777f0 RDI: 00007ffdfef7fb22
2026-03-04T12:23:26.177336+01:00 homer kernel: [T2845420] RBP: 00007f9fb747=
6e50 R08: 00007ffdfef77310 R09: 0000000000000000
2026-03-04T12:23:26.177336+01:00 homer kernel: [T2845420] R10: 000000000000=
0008 R11: 0000000000000206 R12: 00007ffdfef777f0
2026-03-04T12:23:26.177336+01:00 homer kernel: [T2845420] R13: 00007ffdfef7=
7e60 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T12:23:26.177336+01:00 homer kernel: [T2845420]  </TASK>
2026-03-04T12:23:26.177337+01:00 homer kernel: [T2845420] ---[ end trace 00=
00000000000000 ]---

On the third run however I encountered an error which broke everything, i.e=
. the already
running firefox ceased to work, running ps or top in a terminal emulator ga=
ve nothing,
new xfce windows could not be opened and shortly after that the GUI froze. =
(@Lorenzo: This
behaviour strongly reminds me of the maple tree spanning store bug)

2026-03-04T14:30:58.025743+01:00 homer kernel: [T2817909] BUG: unable to ha=
ndle page fault for address: 0000001005a14780
2026-03-04T14:30:58.025762+01:00 homer kernel: [T2817909] #PF: supervisor w=
rite access in kernel mode
2026-03-04T14:30:58.025763+01:00 homer kernel: [T2817909] #PF: error_code(0=
x0002) - not-present page
2026-03-04T14:30:58.025764+01:00 homer kernel: [T2817909] PGD 0 P4D 0=20
2026-03-04T14:30:58.025765+01:00 homer kernel: [T2817909] Oops: Oops: 0002 =
[#1] SMP NOPTI
2026-03-04T14:30:58.025766+01:00 homer kernel: [T2817909] CPU: 24 UID: 1000=
 PID: 2817909 Comm: collect-ld Not tainted 7.0.0-rc2-next-20260303-master #=
367 PREEMPT_RT=20
2026-03-04T14:30:58.025766+01:00 homer kernel: [T2817909] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.025767+01:00 homer kernel: [T2817909] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.025767+01:00 homer kernel: [T2817909] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.025768+01:00 homer kernel: [T2817909] RSP: 0018:ffff9cb=
cec4bb600 EFLAGS: 00010246
2026-03-04T14:30:58.025769+01:00 homer kernel: [T2817909] RAX: 00007feba034=
0f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:30:58.025769+01:00 homer kernel: [T2817909] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:30:58.025770+01:00 homer kernel: [T2817909] RBP: 00007feba034=
0fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:30:58.025770+01:00 homer kernel: [T2817909] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:30:58.025770+01:00 homer kernel: [T2817909] R13: 000000000000=
0002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:30:58.025771+01:00 homer kernel: [T2817909] FS:  000000000000=
0000(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.025771+01:00 homer kernel: [T2817909] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.025771+01:00 homer kernel: [T2817909] CR2: 0000001005a1=
4780 CR3: 00000002744fa000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.025772+01:00 homer kernel: [T2817909] PKRU: 55555554
2026-03-04T14:30:58.025772+01:00 homer kernel: [T2817909] Call Trace:
2026-03-04T14:30:58.025773+01:00 homer kernel: [T2817909]  <TASK>
2026-03-04T14:30:58.025773+01:00 homer kernel: [T2817909]  mas_wr_node_stor=
e+0x9a/0x3f0
2026-03-04T14:30:58.025773+01:00 homer kernel: [T2817909]  ? node_copy.isra=
.0+0x13e/0x400
2026-03-04T14:30:58.025774+01:00 homer kernel: [T2817909]  ? mod_memcg_lruv=
ec_state+0xc4/0x160
2026-03-04T14:30:58.025774+01:00 homer kernel: [T2817909]  ? __account_obj_=
stock+0x18c/0x1f0
2026-03-04T14:30:58.025774+01:00 homer kernel: [T2817909]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.025774+01:00 homer kernel: [T2817909]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.025775+01:00 homer kernel: [T2817909]  ? kmem_cache_all=
oc_noprof+0xd4/0x330
2026-03-04T14:30:58.025775+01:00 homer kernel: [T2817909]  mas_store_preall=
oc+0x19d/0x3d0
2026-03-04T14:30:58.025775+01:00 homer kernel: [T2817909]  __mmap_region+0x=
928/0xf80
2026-03-04T14:30:58.025775+01:00 homer kernel: [T2817909]  do_mmap+0x478/0x=
660
2026-03-04T14:30:58.025775+01:00 homer kernel: [T2817909]  vm_mmap_pgoff+0x=
104/0x190
2026-03-04T14:30:58.025776+01:00 homer kernel: [T2817909]  do_syscall_64+0x=
11b/0x8c0
2026-03-04T14:30:58.025776+01:00 homer kernel: [T2817909]  ? lruvec_stat_mo=
d_folio+0x6f/0xb0
2026-03-04T14:30:58.025776+01:00 homer kernel: [T2817909]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.025776+01:00 homer kernel: [T2817909]  ? try_charge_mem=
cg+0x139/0x6d0
2026-03-04T14:30:58.025777+01:00 homer kernel: [T2817909]  ? flush_tlb_func=
+0x18d/0x1e0
2026-03-04T14:30:58.025777+01:00 homer kernel: [T2817909]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.025777+01:00 homer kernel: [T2817909]  ? set_pte_range+=
0xb5/0x300
2026-03-04T14:30:58.025777+01:00 homer kernel: [T2817909]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.025778+01:00 homer kernel: [T2817909]  ? finish_fault+0=
x256/0x3e0
2026-03-04T14:30:58.025778+01:00 homer kernel: [T2817909]  ? do_fault+0x3db=
/0x640
2026-03-04T14:30:58.025778+01:00 homer kernel: [T2817909]  ? __handle_mm_fa=
ult+0x2c6/0x3a0
2026-03-04T14:30:58.025778+01:00 homer kernel: [T2817909]  ? count_memcg_ev=
ents+0x5e/0xf0
2026-03-04T14:30:58.025778+01:00 homer kernel: [T2817909]  ? handle_mm_faul=
t+0x1b9/0x2c0
2026-03-04T14:30:58.025779+01:00 homer kernel: [T2817909]  ? do_user_addr_f=
ault+0x16e/0x640
2026-03-04T14:30:58.025779+01:00 homer kernel: [T2817909]  entry_SYSCALL_64=
_after_hwframe+0x55/0x5d
2026-03-04T14:30:58.025779+01:00 homer kernel: [T2817909] RIP: 0033:0x7feba=
036bfd2
2026-03-04T14:30:58.025780+01:00 homer kernel: [T2817909] Code: 08 00 04 00=
 00 eb e2 90 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 33=
 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 5b 5d c3 =
0f 1f 00 c7 05 d6 42 01 00 16 00
2026-03-04T14:30:58.025780+01:00 homer kernel: [T2817909] RSP: 002b:00007ff=
c14e91388 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
2026-03-04T14:30:58.025780+01:00 homer kernel: [T2817909] RAX: ffffffffffff=
ffda RBX: 0000000000000000 RCX: 00007feba036bfd2
2026-03-04T14:30:58.025781+01:00 homer kernel: [T2817909] RDX: 000000000000=
0003 RSI: 0000000000002000 RDI: 0000000000000000
2026-03-04T14:30:58.025781+01:00 homer kernel: [T2817909] RBP: 000000000000=
0022 R08: 00000000ffffffff R09: 0000000000000000
2026-03-04T14:30:58.025781+01:00 homer kernel: [T2817909] R10: 000000000000=
0022 R11: 0000000000000246 R12: 0000000000002000
2026-03-04T14:30:58.025781+01:00 homer kernel: [T2817909] R13: 00007feba038=
0310 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T14:30:58.025782+01:00 homer kernel: [T2817909]  </TASK>
2026-03-04T14:30:58.025782+01:00 homer kernel: [T2817909] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.025784+01:00 homer kernel: [T2817909]  gpio_generic
2026-03-04T14:30:58.025784+01:00 homer kernel: [T2817909] CR2: 0000001005a1=
4780
2026-03-04T14:30:58.025785+01:00 homer kernel: [T2817909] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.025785+01:00 homer kernel: [T2817909] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.025785+01:00 homer kernel: [T2817909] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.025785+01:00 homer kernel: [T2817909] RSP: 0018:ffff9cb=
cec4bb600 EFLAGS: 00010246
2026-03-04T14:30:58.025786+01:00 homer kernel: [T2817909] RAX: 00007feba034=
0f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:30:58.025786+01:00 homer kernel: [T2817909] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:30:58.025786+01:00 homer kernel: [T2817909] RBP: 00007feba034=
0fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:30:58.025786+01:00 homer kernel: [T2817909] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:30:58.025787+01:00 homer kernel: [T2817909] R13: 000000000000=
0002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:30:58.025787+01:00 homer kernel: [T2817909] FS:  000000000000=
0000(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.025787+01:00 homer kernel: [T2817909] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.025787+01:00 homer kernel: [T2817909] CR2: 0000001005a1=
4780 CR3: 00000002744fa000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.025788+01:00 homer kernel: [T2817909] PKRU: 55555554
2026-03-04T14:30:58.025788+01:00 homer kernel: [T2817909] note: collect-ld[=
2817909] exited with irqs disabled
2026-03-04T14:30:58.026409+01:00 homer kernel: [T2817909] ------------[ cut=
 here ]------------
2026-03-04T14:30:58.026418+01:00 homer kernel: [T2817909] rtmutex deadlock =
detected
2026-03-04T14:30:58.026419+01:00 homer kernel: [T2817909] WARNING: kernel/l=
ocking/rtmutex.c:1674 at __rt_mutex_slowlock_locked.constprop.0+0x835/0x9b0=
, CPU#24: collect-ld/2817909
2026-03-04T14:30:58.026420+01:00 homer kernel: [T2817909] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.026420+01:00 homer kernel: [T2817909]  gpio_generic
2026-03-04T14:30:58.026421+01:00 homer kernel: [T2817909] CPU: 24 UID: 1000=
 PID: 2817909 Comm: collect-ld Tainted: G      D             7.0.0-rc2-next=
-20260303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.026421+01:00 homer kernel: [T2817909] Tainted: [D]=3DDIE
2026-03-04T14:30:58.026422+01:00 homer kernel: [T2817909] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.026422+01:00 homer kernel: [T2817909] RIP: 0010:__rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0
2026-03-04T14:30:58.026423+01:00 homer kernel: [T2817909] Code: 00 48 89 ef=
 e8 fc 67 87 00 c7 44 24 14 fc ff ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89=
 ef e8 b2 66 87 00 48 8d 3d 2b 58 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 =
e8 87 43 18 e8 e7 6a fd ff eb f4
2026-03-04T14:30:58.026423+01:00 homer kernel: [T2817909] RSP: 0018:ffff9cb=
cec4bbd18 EFLAGS: 00010286
2026-03-04T14:30:58.026423+01:00 homer kernel: [T2817909] RAX: 000000000000=
0000 RBX: ffff9162d3789e80 RCX: ffff9162d3789e81
2026-03-04T14:30:58.026423+01:00 homer kernel: [T2817909] RDX: 000000000000=
0001 RSI: ffff9162d3789e80 RDI: ffffffff85036620
2026-03-04T14:30:58.026424+01:00 homer kernel: [T2817909] RBP: ffff916305d5=
5e38 R08: 0000000000000000 R09: 0000000000000000
2026-03-04T14:30:58.026424+01:00 homer kernel: [T2817909] R10: 000000000000=
0000 R11: 0000000000000003 R12: ffff9cbcec4bbd40
2026-03-04T14:30:58.026425+01:00 homer kernel: [T2817909] R13: ffff9162d378=
9e81 R14: ffff9162d378aac0 R15: 00000000ffffffdd
2026-03-04T14:30:58.026425+01:00 homer kernel: [T2817909] FS:  000000000000=
0000(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.026425+01:00 homer kernel: [T2817909] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.026426+01:00 homer kernel: [T2817909] CR2: 0000001005a1=
4780 CR3: 00000002744fa000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.026426+01:00 homer kernel: [T2817909] PKRU: 55555554
2026-03-04T14:30:58.026426+01:00 homer kernel: [T2817909] Call Trace:
2026-03-04T14:30:58.026427+01:00 homer kernel: [T2817909]  <TASK>
2026-03-04T14:30:58.026427+01:00 homer kernel: [T2817909]  ? psi_task_switc=
h+0x105/0x280
2026-03-04T14:30:58.026427+01:00 homer kernel: [T2817909]  ? finish_task_sw=
itch.isra.0+0xc3/0x370
2026-03-04T14:30:58.026427+01:00 homer kernel: [T2817909]  __rwbase_read_lo=
ck+0x4a/0xd0
2026-03-04T14:30:58.026428+01:00 homer kernel: [T2817909]  acct_collect+0x1=
57/0x1c0
2026-03-04T14:30:58.026428+01:00 homer kernel: [T2817909]  do_exit+0x1c2/0x=
a30
2026-03-04T14:30:58.026428+01:00 homer kernel: [T2817909]  make_task_dead+0=
x94/0xa0
2026-03-04T14:30:58.026428+01:00 homer kernel: [T2817909]  rewind_stack_and=
_make_dead+0x16/0x20
2026-03-04T14:30:58.026429+01:00 homer kernel: [T2817909] RIP: 0033:0x7feba=
036bfd2
2026-03-04T14:30:58.026429+01:00 homer kernel: [T2817909] Code: 08 00 04 00=
 00 eb e2 90 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 33=
 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 5b 5d c3 =
0f 1f 00 c7 05 d6 42 01 00 16 00
2026-03-04T14:30:58.026429+01:00 homer kernel: [T2817909] RSP: 002b:00007ff=
c14e91388 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
2026-03-04T14:30:58.026429+01:00 homer kernel: [T2817909] RAX: ffffffffffff=
ffda RBX: 0000000000000000 RCX: 00007feba036bfd2
2026-03-04T14:30:58.026430+01:00 homer kernel: [T2817909] RDX: 000000000000=
0003 RSI: 0000000000002000 RDI: 0000000000000000
2026-03-04T14:30:58.026430+01:00 homer kernel: [T2817909] RBP: 000000000000=
0022 R08: 00000000ffffffff R09: 0000000000000000
2026-03-04T14:30:58.026430+01:00 homer kernel: [T2817909] R10: 000000000000=
0022 R11: 0000000000000246 R12: 0000000000002000
2026-03-04T14:30:58.026430+01:00 homer kernel: [T2817909] R13: 00007feba038=
0310 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T14:30:58.026430+01:00 homer kernel: [T2817909]  </TASK>
2026-03-04T14:30:58.026431+01:00 homer kernel: [T2817909] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.097449+01:00 homer kernel: [T2817929] BUG: unable to ha=
ndle page fault for address: 0000001006bf7f70
2026-03-04T14:30:58.097464+01:00 homer kernel: [T2817929] #PF: supervisor w=
rite access in kernel mode
2026-03-04T14:30:58.097465+01:00 homer kernel: [T2817929] #PF: error_code(0=
x0002) - not-present page
2026-03-04T14:30:58.097467+01:00 homer kernel: [T2817929] PGD 1015fbc067 P4=
D 1015fbc067 PUD 0=20
2026-03-04T14:30:58.097467+01:00 homer kernel: [T2817929] Oops: Oops: 0002 =
[#2] SMP NOPTI
2026-03-04T14:30:58.097467+01:00 homer kernel: [T2817929] CPU: 24 UID: 1000=
 PID: 2817929 Comm: gnat1 Tainted: G      D W           7.0.0-rc2-next-2026=
0303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.097468+01:00 homer kernel: [T2817929] Tainted: [D]=3DDI=
E, [W]=3DWARN
2026-03-04T14:30:58.097468+01:00 homer kernel: [T2817929] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.097469+01:00 homer kernel: [T2817929] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.097469+01:00 homer kernel: [T2817929] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.097470+01:00 homer kernel: [T2817929] RSP: 0018:ffff9cb=
cea7ff868 EFLAGS: 00010246
2026-03-04T14:30:58.097470+01:00 homer kernel: [T2817929] RAX: 00007fed9cbf=
4f00 RBX: ffff9cbcea7ffcb0 RCX: 0000000000000100
2026-03-04T14:30:58.097470+01:00 homer kernel: [T2817929] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001006bf7f70
2026-03-04T14:30:58.097471+01:00 homer kernel: [T2817929] RBP: 00007fed9cbf=
4fff R08: 0000000000000001 R09: 0000001006bf7f70
2026-03-04T14:30:58.097471+01:00 homer kernel: [T2817929] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000009
2026-03-04T14:30:58.097471+01:00 homer kernel: [T2817929] R13: 000000000000=
0002 R14: 0000001006bf7f70 R15: ffff9cbcea7ff9c8
2026-03-04T14:30:58.097472+01:00 homer kernel: [T2817929] FS:  00007fed9cbf=
0b00(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.097472+01:00 homer kernel: [T2817929] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.097472+01:00 homer kernel: [T2817929] CR2: 0000001006bf=
7f70 CR3: 00000005cab99000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.097472+01:00 homer kernel: [T2817929] PKRU: 55555554
2026-03-04T14:30:58.097473+01:00 homer kernel: [T2817929] Call Trace:
2026-03-04T14:30:58.097473+01:00 homer kernel: [T2817929]  <TASK>
2026-03-04T14:30:58.097473+01:00 homer kernel: [T2817929]  mas_wr_node_stor=
e+0x9a/0x3f0
2026-03-04T14:30:58.097474+01:00 homer kernel: [T2817929]  ? atime_needs_up=
date+0x95/0x110
2026-03-04T14:30:58.097474+01:00 homer kernel: [T2817929]  ? touch_atime+0x=
22/0x190
2026-03-04T14:30:58.097474+01:00 homer kernel: [T2817929]  ? filemap_read+0=
x361/0x390
2026-03-04T14:30:58.097474+01:00 homer kernel: [T2817929]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.097475+01:00 homer kernel: [T2817929]  ? obj_cgroup_cha=
rge_account+0xf2/0x290
2026-03-04T14:30:58.097475+01:00 homer kernel: [T2817929]  mas_store_preall=
oc+0x19d/0x3d0
2026-03-04T14:30:58.097475+01:00 homer kernel: [T2817929]  vma_complete+0x2=
17/0x2c0
2026-03-04T14:30:58.097475+01:00 homer kernel: [T2817929]  __split_vma+0x1d=
0/0x2b0
2026-03-04T14:30:58.097476+01:00 homer kernel: [T2817929]  vms_gather_munma=
p_vmas+0x43/0x340
2026-03-04T14:30:58.097476+01:00 homer kernel: [T2817929]  do_vmi_align_mun=
map+0x152/0x240
2026-03-04T14:30:58.097476+01:00 homer kernel: [T2817929]  ? __x64_sys_clos=
e+0x38/0x80
2026-03-04T14:30:58.097477+01:00 homer kernel: [T2817929]  do_vmi_munmap+0x=
cb/0x160
2026-03-04T14:30:58.097477+01:00 homer kernel: [T2817929]  shrink_vma+0x6b/=
0xd0
2026-03-04T14:30:58.097477+01:00 homer kernel: [T2817929]  __do_sys_mremap+=
0x6c9/0x870
2026-03-04T14:30:58.097477+01:00 homer kernel: [T2817929]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.097477+01:00 homer kernel: [T2817929]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.097478+01:00 homer kernel: [T2817929]  ? do_anonymous_p=
age+0x1a5/0x570
2026-03-04T14:30:58.097478+01:00 homer kernel: [T2817929]  do_syscall_64+0x=
11b/0x8c0
2026-03-04T14:30:58.097478+01:00 homer kernel: [T2817929]  ? handle_mm_faul=
t+0x1b9/0x2c0
2026-03-04T14:30:58.097478+01:00 homer kernel: [T2817929]  ? do_user_addr_f=
ault+0x203/0x640
2026-03-04T14:30:58.097479+01:00 homer kernel: [T2817929]  entry_SYSCALL_64=
_after_hwframe+0x55/0x5d
2026-03-04T14:30:58.097479+01:00 homer kernel: [T2817929] RIP: 0033:0x7fed9=
cd05d20
2026-03-04T14:30:58.097479+01:00 homer kernel: [T2817929] Code: 44 24 40 64=
 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 83 f9 07 77 5a 41 89 ca 45 31=
 c0 f6 c1 06 75 27 b8 19 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 48 8b 54 =
24 18 64 48 2b 14 25 28 00 00 00
2026-03-04T14:30:58.097480+01:00 homer kernel: [T2817929] RSP: 002b:00007ff=
c65acd410 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
2026-03-04T14:30:58.097480+01:00 homer kernel: [T2817929] RAX: ffffffffffff=
ffda RBX: 00007fed9b64f010 RCX: 00007fed9cd05d20
2026-03-04T14:30:58.097480+01:00 homer kernel: [T2817929] RDX: 000000000000=
9000 RSI: 00000000001e9000 RDI: 00007fed9b64f000
2026-03-04T14:30:58.097480+01:00 homer kernel: [T2817929] RBP: 000000000000=
8f70 R08: 0000000000000000 R09: 0000000000009000
2026-03-04T14:30:58.097481+01:00 homer kernel: [T2817929] R10: 000000000000=
0001 R11: 0000000000000246 R12: 00000000001e9000
2026-03-04T14:30:58.097481+01:00 homer kernel: [T2817929] R13: 00000000001e=
9000 R14: 00007fed9b64f000 R15: 0000000000008f80
2026-03-04T14:30:58.097481+01:00 homer kernel: [T2817929]  </TASK>
2026-03-04T14:30:58.097482+01:00 homer kernel: [T2817929] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.097482+01:00 homer kernel: [T2817929]  gpio_generic
2026-03-04T14:30:58.097483+01:00 homer kernel: [T2817929] CR2: 0000001006bf=
7f70
2026-03-04T14:30:58.097483+01:00 homer kernel: [T2817929] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.097483+01:00 homer kernel: [T2817929] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.097483+01:00 homer kernel: [T2817929] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.097484+01:00 homer kernel: [T2817929] RSP: 0018:ffff9cb=
cec4bb600 EFLAGS: 00010246
2026-03-04T14:30:58.097484+01:00 homer kernel: [T2817929] RAX: 00007feba034=
0f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:30:58.097484+01:00 homer kernel: [T2817929] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:30:58.097484+01:00 homer kernel: [T2817929] RBP: 00007feba034=
0fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:30:58.097485+01:00 homer kernel: [T2817929] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:30:58.097485+01:00 homer kernel: [T2817929] R13: 000000000000=
0002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:30:58.097485+01:00 homer kernel: [T2817929] FS:  00007fed9cbf=
0b00(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.097486+01:00 homer kernel: [T2817929] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.097486+01:00 homer kernel: [T2817929] CR2: 0000001006bf=
7f70 CR3: 00000005cab99000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.097486+01:00 homer kernel: [T2817929] PKRU: 55555554
2026-03-04T14:30:58.097487+01:00 homer kernel: [T2817929] note: gnat1[28179=
29] exited with irqs disabled
2026-03-04T14:30:58.097487+01:00 homer kernel: [T2817929] ------------[ cut=
 here ]------------
2026-03-04T14:30:58.097487+01:00 homer kernel: [T2817929] rtmutex deadlock =
detected
2026-03-04T14:30:58.097487+01:00 homer kernel: [T2817929] WARNING: kernel/l=
ocking/rtmutex.c:1674 at __rt_mutex_slowlock_locked.constprop.0+0x835/0x9b0=
, CPU#24: gnat1/2817929
2026-03-04T14:30:58.097496+01:00 homer kernel: [T2817929] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.097496+01:00 homer kernel: [T2817929]  gpio_generic
2026-03-04T14:30:58.097497+01:00 homer kernel: [T2817929] CPU: 24 UID: 1000=
 PID: 2817929 Comm: gnat1 Tainted: G      D W           7.0.0-rc2-next-2026=
0303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.097497+01:00 homer kernel: [T2817929] Tainted: [D]=3DDI=
E, [W]=3DWARN
2026-03-04T14:30:58.097497+01:00 homer kernel: [T2817929] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.097498+01:00 homer kernel: [T2817929] RIP: 0010:__rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0
2026-03-04T14:30:58.097498+01:00 homer kernel: [T2817929] Code: 00 48 89 ef=
 e8 fc 67 87 00 c7 44 24 14 fc ff ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89=
 ef e8 b2 66 87 00 48 8d 3d 2b 58 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 =
e8 87 43 18 e8 e7 6a fd ff eb f4
2026-03-04T14:30:58.097498+01:00 homer kernel: [T2817929] RSP: 0018:ffff9cb=
cea7ffd18 EFLAGS: 00010286
2026-03-04T14:30:58.097499+01:00 homer kernel: [T2817929] RAX: 000000000000=
0000 RBX: ffff9162c30f5b80 RCX: ffff9162c30f5b81
2026-03-04T14:30:58.097499+01:00 homer kernel: [T2817929] RDX: 000000000000=
0001 RSI: ffff9162c30f5b80 RDI: ffffffff85036620
2026-03-04T14:30:58.097499+01:00 homer kernel: [T2817929] RBP: ffff916dd253=
5e38 R08: 0000000000000000 R09: 0000000000000000
2026-03-04T14:30:58.097499+01:00 homer kernel: [T2817929] R10: 000000000000=
0000 R11: 0000000000000003 R12: ffff9cbcea7ffd40
2026-03-04T14:30:58.097500+01:00 homer kernel: [T2817929] R13: ffff9162c30f=
5b81 R14: ffff9162c30f67c0 R15: 00000000ffffffdd
2026-03-04T14:30:58.097500+01:00 homer kernel: [T2817929] FS:  00007fed9cbf=
0b00(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.097500+01:00 homer kernel: [T2817929] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.097500+01:00 homer kernel: [T2817929] CR2: 0000001006bf=
7f70 CR3: 00000005cab99000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.097501+01:00 homer kernel: [T2817929] PKRU: 55555554
2026-03-04T14:30:58.097501+01:00 homer kernel: [T2817929] Call Trace:
2026-03-04T14:30:58.097501+01:00 homer kernel: [T2817929]  <TASK>
2026-03-04T14:30:58.097501+01:00 homer kernel: [T2817929]  ? psi_task_switc=
h+0x105/0x280
2026-03-04T14:30:58.097502+01:00 homer kernel: [T2817929]  ? finish_task_sw=
itch.isra.0+0xc3/0x370
2026-03-04T14:30:58.097503+01:00 homer kernel: [T2817929]  __rwbase_read_lo=
ck+0x4a/0xd0
2026-03-04T14:30:58.097503+01:00 homer kernel: [T2817929]  acct_collect+0x1=
57/0x1c0
2026-03-04T14:30:58.097504+01:00 homer kernel: [T2817929]  do_exit+0x1c2/0x=
a30
2026-03-04T14:30:58.167404+01:00 homer kernel: [T2817929]  make_task_dead+0=
x94/0xa0
2026-03-04T14:30:58.167422+01:00 homer kernel: [T2817929]  rewind_stack_and=
_make_dead+0x16/0x20
2026-03-04T14:30:58.167424+01:00 homer kernel: [T2817929] RIP: 0033:0x7fed9=
cd05d20
2026-03-04T14:30:58.167425+01:00 homer kernel: [T2817929] Code: 44 24 40 64=
 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 83 f9 07 77 5a 41 89 ca 45 31=
 c0 f6 c1 06 75 27 b8 19 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 48 8b 54 =
24 18 64 48 2b 14 25 28 00 00 00
2026-03-04T14:30:58.167425+01:00 homer kernel: [T2817929] RSP: 002b:00007ff=
c65acd410 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
2026-03-04T14:30:58.167426+01:00 homer kernel: [T2817929] RAX: ffffffffffff=
ffda RBX: 00007fed9b64f010 RCX: 00007fed9cd05d20
2026-03-04T14:30:58.167426+01:00 homer kernel: [T2817929] RDX: 000000000000=
9000 RSI: 00000000001e9000 RDI: 00007fed9b64f000
2026-03-04T14:30:58.167427+01:00 homer kernel: [T2817929] RBP: 000000000000=
8f70 R08: 0000000000000000 R09: 0000000000009000
2026-03-04T14:30:58.167427+01:00 homer kernel: [T2817929] R10: 000000000000=
0001 R11: 0000000000000246 R12: 00000000001e9000
2026-03-04T14:30:58.167427+01:00 homer kernel: [T2817929] R13: 00000000001e=
9000 R14: 00007fed9b64f000 R15: 0000000000008f80
2026-03-04T14:30:58.167428+01:00 homer kernel: [T2817929]  </TASK>
2026-03-04T14:30:58.167428+01:00 homer kernel: [T2817929] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.167428+01:00 homer kernel: [T2817974] BUG: unable to ha=
ndle page fault for address: 0000001008dae578
2026-03-04T14:30:58.167428+01:00 homer kernel: [T2817974] #PF: supervisor w=
rite access in kernel mode
2026-03-04T14:30:58.167429+01:00 homer kernel: [T2817974] #PF: error_code(0=
x0002) - not-present page
2026-03-04T14:30:58.167429+01:00 homer kernel: [T2817974] PGD 0 P4D 0=20
2026-03-04T14:30:58.167429+01:00 homer kernel: [T2817974] Oops: Oops: 0002 =
[#3] SMP NOPTI
2026-03-04T14:30:58.167430+01:00 homer kernel: [T2817974] CPU: 24 UID: 1000=
 PID: 2817974 Comm: expect Tainted: G      D W           7.0.0-rc2-next-202=
60303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.167430+01:00 homer kernel: [T2817974] Tainted: [D]=3DDI=
E, [W]=3DWARN
2026-03-04T14:30:58.167430+01:00 homer kernel: [T2817974] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.167430+01:00 homer kernel: [T2817974] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.167431+01:00 homer kernel: [T2817974] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.167431+01:00 homer kernel: [T2817974] RSP: 0018:ffff9cb=
ce7ce7ad8 EFLAGS: 00010246
2026-03-04T14:30:58.167432+01:00 homer kernel: [T2817974] RAX: 00007fffffff=
ef00 RBX: ffff9cbce7ce7cc8 RCX: 0000000000000100
2026-03-04T14:30:58.167432+01:00 homer kernel: [T2817974] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001008dae578
2026-03-04T14:30:58.167432+01:00 homer kernel: [T2817974] RBP: 00007fffffff=
dfff R08: 0000000000000002 R09: 0000001008dae578
2026-03-04T14:30:58.167432+01:00 homer kernel: [T2817974] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000001
2026-03-04T14:30:58.167433+01:00 homer kernel: [T2817974] R13: 000000000000=
0002 R14: 0000001008dae578 R15: ffff9cbce7ce7c38
2026-03-04T14:30:58.167433+01:00 homer kernel: [T2817974] FS:  00007f186e39=
b780(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.167433+01:00 homer kernel: [T2817974] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.167433+01:00 homer kernel: [T2817974] CR2: 0000001008da=
e578 CR3: 0000000dd8ceb000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.167433+01:00 homer kernel: [T2817974] PKRU: 55555554
2026-03-04T14:30:58.167434+01:00 homer kernel: [T2817974] Call Trace:
2026-03-04T14:30:58.167434+01:00 homer kernel: [T2817974]  <TASK>
2026-03-04T14:30:58.167434+01:00 homer kernel: [T2817974]  mas_wr_node_stor=
e+0x9a/0x3f0
2026-03-04T14:30:58.167434+01:00 homer kernel: [T2817974]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.167435+01:00 homer kernel: [T2817974]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.167435+01:00 homer kernel: [T2817974]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.167435+01:00 homer kernel: [T2817974]  ? __folio_batch_=
add_and_move+0x1ad/0x220
2026-03-04T14:30:58.167435+01:00 homer kernel: [T2817974]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.167436+01:00 homer kernel: [T2817974]  ? do_anonymous_p=
age+0x1a5/0x570
2026-03-04T14:30:58.167436+01:00 homer kernel: [T2817974]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.167437+01:00 homer kernel: [T2817974]  ? mt_find+0x92/0=
x3d0
2026-03-04T14:30:58.167437+01:00 homer kernel: [T2817974]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.167437+01:00 homer kernel: [T2817974]  ? kmem_cache_all=
oc_noprof+0xd4/0x330
2026-03-04T14:30:58.167437+01:00 homer kernel: [T2817974]  mas_store_preall=
oc+0x19d/0x3d0
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  expand_downwards=
+0x31c/0x3c0
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  mmap_read_lock_m=
aybe_expand+0x4f/0xb0
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  get_arg_page+0x3=
8/0xf0
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  copy_strings.isr=
a.0+0x114/0x3b0
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  do_execveat_comm=
on.isra.0+0x108/0x170
2026-03-04T14:30:58.167438+01:00 homer kernel: [T2817974]  __x64_sys_execve=
+0x38/0x50
2026-03-04T14:30:58.167439+01:00 homer kernel: [T2817974]  do_syscall_64+0x=
11b/0x8c0
2026-03-04T14:30:58.167439+01:00 homer kernel: [T2817974]  ? do_user_addr_f=
ault+0x203/0x640
2026-03-04T14:30:58.167439+01:00 homer kernel: [T2817974]  entry_SYSCALL_64=
_after_hwframe+0x55/0x5d
2026-03-04T14:30:58.167439+01:00 homer kernel: [T2817974] RIP: 0033:0x7f186=
e58ddd7
2026-03-04T14:30:58.167440+01:00 homer kernel: [T2817974] Code: af e8 ed ed=
 03 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 8b 05 f1 81 10 00 48 8b 10=
 e9 01 00 00 00 90 b8 3b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b =
0d 09 80 10 00 f7 d8 64 89 01 48
2026-03-04T14:30:58.167440+01:00 homer kernel: [T2817974] RSP: 002b:00007ff=
ec3517828 EFLAGS: 00000206 ORIG_RAX: 000000000000003b
2026-03-04T14:30:58.167440+01:00 homer kernel: [T2817974] RAX: ffffffffffff=
ffda RBX: 00007ffec3517960 RCX: 00007f186e58ddd7
2026-03-04T14:30:58.167441+01:00 homer kernel: [T2817974] RDX: 000055ef83b1=
ce80 RSI: 000055ef843585e0 RDI: 00007ffec3517960
2026-03-04T14:30:58.167441+01:00 homer kernel: [T2817974] RBP: 00007ffec351=
78a0 R08: 0000000000000000 R09: 0000000000000000
2026-03-04T14:30:58.167441+01:00 homer kernel: [T2817974] R10: 000000000000=
0007 R11: 0000000000000206 R12: 000055ef843585e0
2026-03-04T14:30:58.167441+01:00 homer kernel: [T2817974] R13: 000055ef83b1=
ce80 R14: 0000000000000001 R15: 0000000000000001
2026-03-04T14:30:58.167442+01:00 homer kernel: [T2817974]  </TASK>
2026-03-04T14:30:58.167442+01:00 homer kernel: [T2817974] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.167443+01:00 homer kernel: [T2817974]  gpio_generic
2026-03-04T14:30:58.167443+01:00 homer kernel: [T2817974] CR2: 0000001008da=
e578
2026-03-04T14:30:58.167444+01:00 homer kernel: [T2817974] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.167444+01:00 homer kernel: [T2817974] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.167444+01:00 homer kernel: [T2817974] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.167444+01:00 homer kernel: [T2817974] RSP: 0018:ffff9cb=
cec4bb600 EFLAGS: 00010246
2026-03-04T14:30:58.167445+01:00 homer kernel: [T2817974] RAX: 00007feba034=
0f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:30:58.167445+01:00 homer kernel: [T2817974] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:30:58.167445+01:00 homer kernel: [T2817974] RBP: 00007feba034=
0fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:30:58.167446+01:00 homer kernel: [T2817974] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:30:58.167446+01:00 homer kernel: [T2817974] R13: 000000000000=
0002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:30:58.167446+01:00 homer kernel: [T2817974] FS:  00007f186e39=
b780(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.167446+01:00 homer kernel: [T2817974] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.167447+01:00 homer kernel: [T2817974] CR2: 0000001008da=
e578 CR3: 0000000dd8ceb000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.167447+01:00 homer kernel: [T2817974] PKRU: 55555554
2026-03-04T14:30:58.167447+01:00 homer kernel: [T2817974] note: expect[2817=
974] exited with irqs disabled
2026-03-04T14:30:58.246062+01:00 homer kernel: [T1865813] BUG: kernel NULL =
pointer dereference, address: 0000000000000000
2026-03-04T14:30:58.246079+01:00 homer kernel: [T1865813] #PF: supervisor w=
rite access in kernel mode
2026-03-04T14:30:58.246081+01:00 homer kernel: [T1865813] #PF: error_code(0=
x0002) - not-present page
2026-03-04T14:30:58.246082+01:00 homer kernel: [T1865813] PGD 0 P4D 0=20
2026-03-04T14:30:58.246082+01:00 homer kernel: [T1865813] Oops: Oops: 0002 =
[#4] SMP NOPTI
2026-03-04T14:30:58.246083+01:00 homer kernel: [T1865813] CPU: 24 UID: 1000=
 PID: 1865813 Comm: expect Tainted: G      D W           7.0.0-rc2-next-202=
60303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.246083+01:00 homer kernel: [T1865813] Tainted: [D]=3DDI=
E, [W]=3DWARN
2026-03-04T14:30:58.246084+01:00 homer kernel: [T1865813] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.246084+01:00 homer kernel: [T1865813] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.246085+01:00 homer kernel: [T1865813] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.246085+01:00 homer kernel: [T1865813] RSP: 0018:ffff9cb=
ccd6c7818 EFLAGS: 00010246
2026-03-04T14:30:58.246086+01:00 homer kernel: [T1865813] RAX: 000000000000=
0000 RBX: ffff916493ce4650 RCX: 0000000000000100
2026-03-04T14:30:58.246086+01:00 homer kernel: [T1865813] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000000000000000
2026-03-04T14:30:58.246086+01:00 homer kernel: [T1865813] RBP: ffff9cbccd6c=
7880 R08: ffff916493ce4600 R09: 0000000000000000
2026-03-04T14:30:58.246087+01:00 homer kernel: [T1865813] R10: 000000000000=
0005 R11: ffffffff84a728dc R12: ffff9162d364cb50
2026-03-04T14:30:58.246087+01:00 homer kernel: [T1865813] R13: ffff916493ce=
4678 R14: 000000000000000c R15: 1ffff22c9279c8c3
2026-03-04T14:30:58.246087+01:00 homer kernel: [T1865813] FS:  00007f186e39=
b780(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.246088+01:00 homer kernel: [T1865813] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.246088+01:00 homer kernel: [T1865813] CR2: 000000000000=
0000 CR3: 0000000ffa751000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.246088+01:00 homer kernel: [T1865813] PKRU: 55555554
2026-03-04T14:30:58.246089+01:00 homer kernel: [T1865813] Call Trace:
2026-03-04T14:30:58.246089+01:00 homer kernel: [T1865813]  <TASK>
2026-03-04T14:30:58.246089+01:00 homer kernel: [T1865813]  mas_dup_alloc.is=
ra.0+0x14a/0x390
2026-03-04T14:30:58.246090+01:00 homer kernel: [T1865813]  ? kmem_cache_all=
oc_noprof+0xd4/0x330
2026-03-04T14:30:58.246090+01:00 homer kernel: [T1865813]  __mt_dup+0x21c/0=
x5d0
2026-03-04T14:30:58.246094+01:00 homer kernel: [T1865813]  ? try_charge_mem=
cg+0x139/0x6d0
2026-03-04T14:30:58.246095+01:00 homer kernel: [T1865813]  dup_mmap+0xfc/0x=
7e0
2026-03-04T14:30:58.246095+01:00 homer kernel: [T1865813]  copy_process+0x1=
017/0x1a90
2026-03-04T14:30:58.246096+01:00 homer kernel: [T1865813]  kernel_clone+0x9=
3/0x400
2026-03-04T14:30:58.246096+01:00 homer kernel: [T1865813]  __do_sys_clone+0=
x65/0x90
2026-03-04T14:30:58.246097+01:00 homer kernel: [T1865813]  do_syscall_64+0x=
11b/0x8c0
2026-03-04T14:30:58.246097+01:00 homer kernel: [T1865813]  ? security_file_=
alloc+0x46/0xa0
2026-03-04T14:30:58.246097+01:00 homer kernel: [T1865813]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.246097+01:00 homer kernel: [T1865813]  ? init_file+0x45=
/0x110
2026-03-04T14:30:58.246098+01:00 homer kernel: [T1865813]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.246098+01:00 homer kernel: [T1865813]  ? alloc_fd+0x118=
/0x180
2026-03-04T14:30:58.246098+01:00 homer kernel: [T1865813]  ? __do_pipe_flag=
s.part.0+0x22/0xa0
2026-03-04T14:30:58.246099+01:00 homer kernel: [T1865813]  ? do_pipe2+0xd1/=
0x110
2026-03-04T14:30:58.246099+01:00 homer kernel: [T1865813]  ? __x64_sys_pipe=
2+0x13/0x20
2026-03-04T14:30:58.246099+01:00 homer kernel: [T1865813]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.246099+01:00 homer kernel: [T1865813]  ? do_wp_page+0x7=
9c/0xe90
2026-03-04T14:30:58.246100+01:00 homer kernel: [T1865813]  ? proc_pid_readl=
ink+0x12b/0x1a0
2026-03-04T14:30:58.246100+01:00 homer kernel: [T1865813]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.246100+01:00 homer kernel: [T1865813]  ? rt_spin_lock+0=
x38/0x110
2026-03-04T14:30:58.246100+01:00 homer kernel: [T1865813]  ? rt_spin_unlock=
+0x5a/0xa0
2026-03-04T14:30:58.246101+01:00 homer kernel: [T1865813]  ? __x64_sys_rt_s=
igprocmask+0xde/0x140
2026-03-04T14:30:58.246101+01:00 homer kernel: [T1865813]  ? do_syscall_64+=
0x11b/0x8c0
2026-03-04T14:30:58.246101+01:00 homer kernel: [T1865813]  ? count_memcg_ev=
ents+0x5e/0xf0
2026-03-04T14:30:58.246101+01:00 homer kernel: [T1865813]  ? handle_mm_faul=
t+0x1b9/0x2c0
2026-03-04T14:30:58.246102+01:00 homer kernel: [T1865813]  ? do_user_addr_f=
ault+0x203/0x640
2026-03-04T14:30:58.246102+01:00 homer kernel: [T1865813]  entry_SYSCALL_64=
_after_hwframe+0x55/0x5d
2026-03-04T14:30:58.246103+01:00 homer kernel: [T1865813] RIP: 0033:0x7f186=
e58d202
2026-03-04T14:30:58.246103+01:00 homer kernel: [T1865813] Code: 89 e7 e8 91=
 3b f6 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c=
 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 89 c5 85 =
c0 75 31 64 48 8b 04 25 10 00 00
2026-03-04T14:30:58.246104+01:00 homer kernel: [T1865813] RSP: 002b:00007ff=
ec3517780 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
2026-03-04T14:30:58.246104+01:00 homer kernel: [T1865813] RAX: ffffffffffff=
ffda RBX: 00007ffec3517780 RCX: 00007f186e58d202
2026-03-04T14:30:58.246104+01:00 homer kernel: [T1865813] RDX: 000000000000=
0000 RSI: 0000000000000000 RDI: 0000000001200011
2026-03-04T14:30:58.246105+01:00 homer kernel: [T1865813] RBP: 00007f186e78=
77e0 R08: 0000000000000000 R09: 0000000000000002
2026-03-04T14:30:58.246105+01:00 homer kernel: [T1865813] R10: 00007f186e39=
ba50 R11: 0000000000000246 R12: 00007ffec35177b0
2026-03-04T14:30:58.246105+01:00 homer kernel: [T1865813] R13: 000000000000=
0001 R14: 0000000000000001 R15: 0000000000000006
2026-03-04T14:30:58.246106+01:00 homer kernel: [T1865813]  </TASK>
2026-03-04T14:30:58.246106+01:00 homer kernel: [T1865813] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.246107+01:00 homer kernel: [T1865813]  gpio_generic
2026-03-04T14:30:58.246107+01:00 homer kernel: [T1865813] CR2: 000000000000=
0000
2026-03-04T14:30:58.246108+01:00 homer kernel: [T1865813] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.246108+01:00 homer kernel: [T1865813] RIP: 0010:memset+=
0xf/0x20
2026-03-04T14:30:58.246108+01:00 homer kernel: [T1865813] Code: 44 89 54 17=
 fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f=
 1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f =
1f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:30:58.246109+01:00 homer kernel: [T1865813] RSP: 0018:ffff9cb=
cec4bb600 EFLAGS: 00010246
2026-03-04T14:30:58.246109+01:00 homer kernel: [T1865813] RAX: 00007feba034=
0f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:30:58.246109+01:00 homer kernel: [T1865813] RDX: 000000000000=
0100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:30:58.246109+01:00 homer kernel: [T1865813] RBP: 00007feba034=
0fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:30:58.246110+01:00 homer kernel: [T1865813] R10: 000000000000=
0008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:30:58.246110+01:00 homer kernel: [T1865813] R13: 000000000000=
0002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:30:58.246111+01:00 homer kernel: [T1865813] FS:  00007f186e39=
b780(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.246111+01:00 homer kernel: [T1865813] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.246111+01:00 homer kernel: [T1865813] CR2: 000000000000=
0000 CR3: 0000000ffa751000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.246112+01:00 homer kernel: [T1865813] PKRU: 55555554
2026-03-04T14:30:58.246112+01:00 homer kernel: [T1865813] note: expect[1865=
813] exited with irqs disabled
2026-03-04T14:30:58.246421+01:00 homer kernel: [T1865813] ------------[ cut=
 here ]------------
2026-03-04T14:30:58.246431+01:00 homer kernel: [T1865813] rtmutex deadlock =
detected
2026-03-04T14:30:58.246432+01:00 homer kernel: [T1865813] WARNING: kernel/l=
ocking/rtmutex.c:1674 at __rt_mutex_slowlock_locked.constprop.0+0x835/0x9b0=
, CPU#24: expect/1865813
2026-03-04T14:30:58.246433+01:00 homer kernel: [T1865813] Modules linked in=
: ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfa=
t fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt=
7925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl=
_msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_=
ump snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmo=
f snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap=
_i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp =
evdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 e=
xt4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit =
drm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_pane=
l_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pc=
i libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core sc=
si_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth h=
kdf video wmi gpio_amdpt
2026-03-04T14:30:58.246434+01:00 homer kernel: [T1865813]  gpio_generic
2026-03-04T14:30:58.246434+01:00 homer kernel: [T1865813] CPU: 24 UID: 1000=
 PID: 1865813 Comm: expect Tainted: G      D W           7.0.0-rc2-next-202=
60303-master #367 PREEMPT_RT=20
2026-03-04T14:30:58.246435+01:00 homer kernel: [T1865813] Tainted: [D]=3DDI=
E, [W]=3DWARN
2026-03-04T14:30:58.246435+01:00 homer kernel: [T1865813] Hardware name: AS=
US System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:30:58.246435+01:00 homer kernel: [T1865813] RIP: 0010:__rt_mu=
tex_slowlock_locked.constprop.0+0x835/0x9b0
2026-03-04T14:30:58.246436+01:00 homer kernel: [T1865813] Code: 00 48 89 ef=
 e8 fc 67 87 00 c7 44 24 14 fc ff ff ff 41 83 ff dd 0f 85 87 fd ff ff 48 89=
 ef e8 b2 66 87 00 48 8d 3d 2b 58 f2 00 <67> 48 0f b9 3a bd 01 00 00 00 89 =
e8 87 43 18 e8 e7 6a fd ff eb f4
2026-03-04T14:30:58.246436+01:00 homer kernel: [T1865813] RSP: 0018:ffff9cb=
ccd6c7db8 EFLAGS: 00010286
2026-03-04T14:30:58.246437+01:00 homer kernel: [T1865813] RAX: 000000000000=
0000 RBX: ffff91715d118000 RCX: ffff91715d118001
2026-03-04T14:30:58.246437+01:00 homer kernel: [T1865813] RDX: 000000000000=
0001 RSI: ffff91715d118000 RDI: ffffffff85036620
2026-03-04T14:30:58.246438+01:00 homer kernel: [T1865813] RBP: ffff91632b77=
cbb8 R08: 0000000000007f18 R09: 0000000effbd0067
2026-03-04T14:30:58.246438+01:00 homer kernel: [T1865813] R10: 000000006e39=
b000 R11: 0000000000000a52 R12: ffff9cbccd6c7de0
2026-03-04T14:30:58.246438+01:00 homer kernel: [T1865813] R13: ffff91715d11=
8001 R14: ffff91715d118c40 R15: 00000000ffffffdd
2026-03-04T14:30:58.246439+01:00 homer kernel: [T1865813] FS:  000000000000=
0000(0000) GS:ffff9172784e1000(0000) knlGS:0000000000000000
2026-03-04T14:30:58.246439+01:00 homer kernel: [T1865813] CS:  0010 DS: 000=
0 ES: 0000 CR0: 0000000080050033
2026-03-04T14:30:58.246439+01:00 homer kernel: [T1865813] CR2: 00007fa449d7=
d370 CR3: 0000000ffa751000 CR4: 0000000000f50ef0
2026-03-04T14:30:58.246439+01:00 homer kernel: [T1865813] PKRU: 55555554
2026-03-04T14:30:58.246440+01:00 homer kernel: [T1865813] Call Trace:
2026-03-04T14:30:58.246440+01:00 homer kernel: [T1865813]  <TASK>
2026-03-04T14:30:58.246441+01:00 homer kernel: [T1865813]  ? futex_hash+0x8=
1/0x90
2026-03-04T14:30:58.246441+01:00 homer kernel: [T1865813]  ? futex_wake+0xa=
c/0x1c0
2026-03-04T14:30:58.246441+01:00 homer kernel: [T1865813]  __rwbase_read_lo=
ck+0x4a/0xd0
2026-03-04T14:30:58.246441+01:00 homer kernel: [T1865813]  do_exit+0x220/0x=
a30
2026-03-04T14:30:58.246442+01:00 homer kernel: [T1865813]  make_task_dead+0=
x94/0xa0
2026-03-04T14:30:58.246442+01:00 homer kernel: [T1865813]  rewind_stack_and=
_make_dead+0x16/0x20
2026-03-04T14:30:58.246442+01:00 homer kernel: [T1865813] RIP: 0033:0x7f186=
e58d202
2026-03-04T14:30:58.246443+01:00 homer kernel: [T1865813] Code: 89 e7 e8 91=
 3b f6 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c=
 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 89 c5 85 =
c0 75 31 64 48 8b 04 25 10 00 00
2026-03-04T14:30:58.246443+01:00 homer kernel: [T1865813] RSP: 002b:00007ff=
ec3517780 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
2026-03-04T14:30:58.246443+01:00 homer kernel: [T1865813] RAX: ffffffffffff=
ffda RBX: 00007ffec3517780 RCX: 00007f186e58d202
2026-03-04T14:30:58.246444+01:00 homer kernel: [T1865813] RDX: 000000000000=
0000 RSI: 0000000000000000 RDI: 0000000001200011
2026-03-04T14:30:58.246444+01:00 homer kernel: [T1865813] RBP: 00007f186e78=
77e0 R08: 0000000000000000 R09: 0000000000000002
2026-03-04T14:30:58.246444+01:00 homer kernel: [T1865813] R10: 00007f186e39=
ba50 R11: 0000000000000246 R12: 00007ffec35177b0
2026-03-04T14:30:58.246445+01:00 homer kernel: [T1865813] R13: 000000000000=
0001 R14: 0000000000000001 R15: 0000000000000006
2026-03-04T14:30:58.246445+01:00 homer kernel: [T1865813]  </TASK>
2026-03-04T14:30:58.246446+01:00 homer kernel: [T1865813] ---[ end trace 00=
00000000000000 ]---
2026-03-04T14:30:58.253423+01:00 homer kernel: [  T240] BUG: Bad rss-counte=
r state mm:000000008aaa6644 type:MM_ANONPAGES val:1 Comm:rcuc/24 Pid:240
2026-03-04T14:31:39.683836+01:00 homer kernel: [T487677] BUG: kernel NULL p=
ointer dereference, address: 0000000000000402
2026-03-04T14:31:39.683847+01:00 homer kernel: [T487677] #PF: supervisor re=
ad access in kernel mode
2026-03-04T14:31:39.683849+01:00 homer kernel: [T487677] #PF: error_code(0x=
0000) - not-present page
2026-03-04T14:31:39.683849+01:00 homer kernel: [T487677] PGD 0 P4D 0=20
2026-03-04T14:31:39.683850+01:00 homer kernel: [T487677] Oops: Oops: 0000 [=
#5] SMP NOPTI
2026-03-04T14:31:39.683850+01:00 homer kernel: [T487677] CPU: 13 UID: 0 PID=
: 487677 Comm: kworker/u130:4 Tainted: G      D W           7.0.0-rc2-next-=
20260303-master #367 PREEMPT_RT=20
2026-03-04T14:31:39.683851+01:00 homer kernel: [T487677] Tainted: [D]=3DDIE=
, [W]=3DWARN
2026-03-04T14:31:39.683856+01:00 homer kernel: [T487677] Hardware name: ASU=
S System Product Name/ROG STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
2026-03-04T14:31:39.683856+01:00 homer kernel: [T487677] Workqueue: events_=
unbound flush_to_ldisc
2026-03-04T14:31:39.683857+01:00 homer kernel: [T487677] RIP: 0010:__send_s=
ignal_locked+0x14c/0x320
2026-03-04T14:31:39.683857+01:00 homer kernel: [T487677] Code: 10 83 fb 01 =
76 5c 49 8b 84 24 70 0b 00 00 48 8b 40 70 48 85 c0 74 4b 48 83 e8 08 74 45 =
be 00 00 3c 00 c4 e2 93 f7 f6 83 e6 01 <48> 8b 10 83 fd 12 0f 84 d5 00 00 0=
0 41 83 fd 1e 77 11 48 89 d7 48
2026-03-04T14:31:39.683857+01:00 homer kernel: [T487677] RSP: 0018:ffff9cbc=
e3bdbc10 EFLAGS: 00010202
2026-03-04T14:31:39.683858+01:00 homer kernel: [T487677] RAX: 0000000000000=
402 RBX: 0000000000000002 RCX: 0000000000000002
2026-03-04T14:31:39.683858+01:00 homer kernel: [T487677] RDX: 0000000000000=
402 RSI: 0000000000000000 RDI: 0000000000000400
2026-03-04T14:31:39.683858+01:00 homer kernel: [T487677] RBP: 0000000000000=
002 R08: ffff9cbce3bdbbd0 R09: 0000000000000001
2026-03-04T14:31:39.683859+01:00 homer kernel: [T487677] R10: 0000000000000=
001 R11: 000000000000001e R12: ffff91715d118000
2026-03-04T14:31:39.683859+01:00 homer kernel: [T487677] R13: 0000000000000=
001 R14: 0000000000000001 R15: ffff916305b36958
2026-03-04T14:31:39.683859+01:00 homer kernel: [T487677] FS:  0000000000000=
000(0000) GS:ffff917278221000(0000) knlGS:0000000000000000
2026-03-04T14:31:39.683859+01:00 homer kernel: [T487677] CS:  0010 DS: 0000=
 ES: 0000 CR0: 0000000080050033
2026-03-04T14:31:39.683859+01:00 homer kernel: [T487677] CR2: 0000000000000=
402 CR3: 0000000146df4000 CR4: 0000000000f50ef0
2026-03-04T14:31:39.683860+01:00 homer kernel: [T487677] PKRU: 55555554
2026-03-04T14:31:39.683860+01:00 homer kernel: [T487677] Call Trace:
2026-03-04T14:31:39.683860+01:00 homer kernel: [T487677]  <TASK>
2026-03-04T14:31:39.683860+01:00 homer kernel: [T487677]  do_send_sig_info+=
0x53/0xa0
2026-03-04T14:31:39.683860+01:00 homer kernel: [T487677]  __kill_pgrp_info+=
0x71/0xb0
2026-03-04T14:31:39.683861+01:00 homer kernel: [T487677]  kill_pgrp+0x2f/0x=
50
2026-03-04T14:31:39.683861+01:00 homer kernel: [T487677]  isig+0x89/0x190
2026-03-04T14:31:39.683861+01:00 homer kernel: [T487677]  n_tty_receive_sig=
nal_char+0x11/0x60
2026-03-04T14:31:39.683861+01:00 homer kernel: [T487677]  n_tty_receive_buf=
_standard+0x3e7/0xac0
2026-03-04T14:31:39.683862+01:00 homer kernel: [T487677]  n_tty_receive_buf=
_common+0x10e/0x730
2026-03-04T14:31:39.683862+01:00 homer kernel: [T487677]  tty_port_default_=
receive_buf+0x3d/0x70
2026-03-04T14:31:39.683862+01:00 homer kernel: [T487677]  flush_to_ldisc+0x=
97/0x1a0
2026-03-04T14:31:39.683863+01:00 homer kernel: [T487677]  process_one_work+=
0x18e/0x280
2026-03-04T14:31:39.683863+01:00 homer kernel: [T487677]  worker_thread+0x1=
94/0x2f0
2026-03-04T14:31:39.683863+01:00 homer kernel: [T487677]  ? rescuer_thread+=
0x590/0x590
2026-03-04T14:31:39.683863+01:00 homer kernel: [T487677]  kthread+0xd0/0x100
2026-03-04T14:31:39.683864+01:00 homer kernel: [T487677]  ? kthreads_online=
_cpu+0x10/0x10
2026-03-04T14:31:39.683864+01:00 homer kernel: [T487677]  ret_from_fork+0x2=
b1/0x340
2026-03-04T14:31:39.683864+01:00 homer kernel: [T487677]  ? kthreads_online=
_cpu+0x10/0x10
2026-03-04T14:31:39.683864+01:00 homer kernel: [T487677]  ret_from_fork_asm=
+0x11/0x20
2026-03-04T14:31:39.683864+01:00 homer kernel: [T487677]  </TASK>
2026-03-04T14:31:39.683865+01:00 homer kernel: [T487677] Modules linked in:=
 ccm rfcomm bnep snd_seq_dummy snd_hrtimer snd_seq nls_ascii nls_cp437 vfat=
 fat btusb btrtl btintel btbcm btmtk bluetooth ecdh_generic ecc mt7925e mt7=
925_common joydev snd_usb_audio mt792x_lib mt76_connac_lib mt76 intel_rapl_=
msr snd_hda_codec_atihdmi snd_hda_codec_hdmi snd_usbmidi_lib mac80211 snd_u=
mp snd_rawmidi intel_rapl_common snd_seq_device snd_hda_intel rapl wmi_bmof=
 snd_hda_codec pcspkr snd_hda_core libarc4 spd5118 snd_intel_dspcfg regmap_=
i2c snd_hwdep snd_pcm cfg80211 snd_timer snd soundcore rfkill k10temp ccp e=
vdev nct6775 nct6775_core hwmon_vid configfs efi_pstore efivarfs autofs4 ex=
t4 mbcache jbd2 hid_generic usbhid hid amdgpu drm_client_lib i2c_algo_bit d=
rm_buddy drm_ttm_helper ttm drm_exec drm_suballoc_helper mfd_core drm_panel=
_backlight_quirks gpu_sched amdxcp drm_display_helper ahci libahci xhci_pci=
 libata xhci_hcd drm_kms_helper drm usbcore scsi_mod nvme igc nvme_core scs=
i_common cec i2c_piix4 i2c_smbus usb_common crc16 nvme_keyring nvme_auth hk=
df video wmi gpio_amdpt
2026-03-04T14:31:39.683866+01:00 homer kernel: [T487677]  gpio_generic
2026-03-04T14:31:39.683866+01:00 homer kernel: [T487677] CR2: 0000000000000=
402
2026-03-04T14:31:39.683866+01:00 homer kernel: [T487677] ---[ end trace 000=
0000000000000 ]---
2026-03-04T14:31:39.683866+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: ERROR unknown event type 37
2026-03-04T14:31:39.688420+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688431+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688432+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688432+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688432+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688439+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688439+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688440+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688440+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688440+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688441+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688441+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688442+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688442+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688443+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688443+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688444+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688444+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688444+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688445+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688445+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688446+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688446+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688447+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688447+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688448+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688448+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688449+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.688449+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.688453+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.691335+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.691339+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.691340+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.691340+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.691341+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 8 on endpoint
2026-03-04T14:31:39.691342+01:00 homer kernel: [  T584] xhci_hcd 0000:0b:00=
.0: WARN: buffer overrun event for slot 1 ep 6 on endpoint
2026-03-04T14:31:39.718573+01:00 homer kernel: [T487677] pstore: backend (e=
fi_pstore) writing error (-28)
2026-03-04T14:31:39.718582+01:00 homer kernel: [T487677] RIP: 0010:memset+0=
xf/0x20
2026-03-04T14:31:39.718583+01:00 homer kernel: [T487677] Code: 44 89 54 17 =
fe eb 0c 48 83 fa 01 72 06 44 8a 1e 44 88 1f c3 cc cc cc cc 0f 1f 00 f3 0f =
1e fa 66 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 cc cc cc cc 0f 1=
f 80 00 00 00 00 49 89 fa 40 0f
2026-03-04T14:31:39.718584+01:00 homer kernel: [T487677] RSP: 0018:ffff9cbc=
ec4bb600 EFLAGS: 00010246
2026-03-04T14:31:39.718595+01:00 homer kernel: [T487677] RAX: 00007feba0340=
f00 RBX: ffff9cbcec4bb7f0 RCX: 0000000000000100
2026-03-04T14:31:39.718596+01:00 homer kernel: [T487677] RDX: 0000000000000=
100 RSI: 0000000000000000 RDI: 0000001005a14780
2026-03-04T14:31:39.718597+01:00 homer kernel: [T487677] RBP: 00007feba0340=
fff R08: 0000000000000007 R09: 0000001005a14780
2026-03-04T14:31:39.718597+01:00 homer kernel: [T487677] R10: 0000000000000=
008 R11: 0000000000000000 R12: 0000000000000007
2026-03-04T14:31:39.718597+01:00 homer kernel: [T487677] R13: 0000000000000=
002 R14: 0000001005a14780 R15: ffff9cbcec4bb760
2026-03-04T14:31:39.718598+01:00 homer kernel: [T487677] FS:  0000000000000=
000(0000) GS:ffff917278221000(0000) knlGS:0000000000000000
2026-03-04T14:31:39.718598+01:00 homer kernel: [T487677] CS:  0010 DS: 0000=
 ES: 0000 CR0: 0000000080050033
2026-03-04T14:31:39.718599+01:00 homer kernel: [T487677] CR2: 0000000000000=
402 CR3: 0000000e9b622000 CR4: 0000000000f50ef0
2026-03-04T14:31:39.718599+01:00 homer kernel: [T487677] PKRU: 55555554
2026-03-04T14:31:39.718600+01:00 homer kernel: [T487677] note: kworker/u130=
:4[487677] exited with irqs disabled
2026-03-04T14:31:59.527451+01:00 homer kernel: [   C31] rcu: INFO: rcu_pree=
mpt detected stalls on CPUs/tasks:
2026-03-04T14:31:59.527461+01:00 homer kernel: [   C31] rcu: 	Tasks blocked=
 on level-1 rcu_node (CPUs 0-15): P487677/2:b..l
2026-03-04T14:31:59.527462+01:00 homer kernel: [   C31] rcu: 	(detected by =
31, t=3D21002 jiffies, g=3D1779997, q=3D1889 ncpus=3D32)
2026-03-04T14:31:59.527462+01:00 homer kernel: [   C31] task:kworker/u130:4=
  state:D stack:0     pid:487677 tgid:487677 ppid:2      task_flags:0x42080=
6c flags:0x00080000
2026-03-04T14:31:59.527463+01:00 homer kernel: [   C31] Workqueue: events_u=
nbound flush_to_ldisc
2026-03-04T14:31:59.527463+01:00 homer kernel: [   C31] Call Trace:
2026-03-04T14:31:59.527463+01:00 homer kernel: [   C31]  <TASK>
2026-03-04T14:31:59.527464+01:00 homer kernel: [   C31]  __schedule+0x47f/0=
xed0
2026-03-04T14:31:59.527464+01:00 homer kernel: [   C31]  schedule_rtlock+0x=
1e/0x40
2026-03-04T14:31:59.527464+01:00 homer kernel: [   C31]  rtlock_slowlock_lo=
cked+0x307/0xe70
2026-03-04T14:31:59.527465+01:00 homer kernel: [   C31]  ? sched_clock+0x10=
/0x30
2026-03-04T14:31:59.527465+01:00 homer kernel: [   C31]  rt_write_lock+0x18=
4/0x1e0
2026-03-04T14:31:59.527465+01:00 homer kernel: [   C31]  do_exit+0x30c/0xa30
2026-03-04T14:31:59.527465+01:00 homer kernel: [   C31]  make_task_dead+0x9=
4/0xa0
2026-03-04T14:31:59.527466+01:00 homer kernel: [   C31]  rewind_stack_and_m=
ake_dead+0x16/0x20
2026-03-04T14:31:59.527466+01:00 homer kernel: [   C31] RIP: 0000:0x0
2026-03-04T14:31:59.527466+01:00 homer kernel: [   C31] Code: Unable to acc=
ess opcode bytes at 0xffffffffffffffd6.
2026-03-04T14:31:59.527466+01:00 homer kernel: [   C31] RSP: 0000:000000000=
0000000 EFLAGS: 00000000 ORIG_RAX: 0000000000000000
2026-03-04T14:31:59.527466+01:00 homer kernel: [   C31] RAX: 00000000000000=
00 RBX: 0000000000000000 RCX: 0000000000000000
2026-03-04T14:31:59.527467+01:00 homer kernel: [   C31] RDX: 00000000000000=
00 RSI: 0000000000000000 RDI: 0000000000000000
2026-03-04T14:31:59.527467+01:00 homer kernel: [   C31] RBP: 00000000000000=
00 R08: 0000000000000000 R09: 0000000000000000
2026-03-04T14:31:59.527467+01:00 homer kernel: [   C31] R10: 00000000000000=
00 R11: 0000000000000000 R12: 0000000000000000
2026-03-04T14:31:59.527467+01:00 homer kernel: [   C31] R13: 00000000000000=
00 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T14:31:59.527468+01:00 homer kernel: [   C31]  </TASK>
2026-03-04T14:33:02.532443+01:00 homer kernel: [    C2] rcu: INFO: rcu_pree=
mpt detected stalls on CPUs/tasks:
2026-03-04T14:33:02.532451+01:00 homer kernel: [    C2] rcu: 	Tasks blocked=
 on level-1 rcu_node (CPUs 0-15): P487677/2:b..l
2026-03-04T14:33:02.532452+01:00 homer kernel: [    C2] rcu: 	(detected by =
2, t=3D84007 jiffies, g=3D1779997, q=3D3508 ncpus=3D32)
2026-03-04T14:33:02.532452+01:00 homer kernel: [    C2] task:kworker/u130:4=
  state:D stack:0     pid:487677 tgid:487677 ppid:2      task_flags:0x42080=
6c flags:0x00080000
2026-03-04T14:33:02.532452+01:00 homer kernel: [    C2] Workqueue: events_u=
nbound flush_to_ldisc
2026-03-04T14:33:02.532453+01:00 homer kernel: [    C2] Call Trace:
2026-03-04T14:33:02.532458+01:00 homer kernel: [    C2]  <TASK>
2026-03-04T14:33:02.532458+01:00 homer kernel: [    C2]  __schedule+0x47f/0=
xed0
2026-03-04T14:33:02.532458+01:00 homer kernel: [    C2]  schedule_rtlock+0x=
1e/0x40
2026-03-04T14:33:02.532459+01:00 homer kernel: [    C2]  rtlock_slowlock_lo=
cked+0x307/0xe70
2026-03-04T14:33:02.532459+01:00 homer kernel: [    C2]  ? sched_clock+0x10=
/0x30
2026-03-04T14:33:02.532459+01:00 homer kernel: [    C2]  rt_write_lock+0x18=
4/0x1e0
2026-03-04T14:33:02.532459+01:00 homer kernel: [    C2]  do_exit+0x30c/0xa30
2026-03-04T14:33:02.532460+01:00 homer kernel: [    C2]  make_task_dead+0x9=
4/0xa0
2026-03-04T14:33:02.532460+01:00 homer kernel: [    C2]  rewind_stack_and_m=
ake_dead+0x16/0x20
2026-03-04T14:33:02.532460+01:00 homer kernel: [    C2] RIP: 0000:0x0
2026-03-04T14:33:02.532461+01:00 homer kernel: [    C2] Code: Unable to acc=
ess opcode bytes at 0xffffffffffffffd6.
2026-03-04T14:33:02.532461+01:00 homer kernel: [    C2] RSP: 0000:000000000=
0000000 EFLAGS: 00000000 ORIG_RAX: 0000000000000000
2026-03-04T14:33:02.532461+01:00 homer kernel: [    C2] RAX: 00000000000000=
00 RBX: 0000000000000000 RCX: 0000000000000000
2026-03-04T14:33:02.532461+01:00 homer kernel: [    C2] RDX: 00000000000000=
00 RSI: 0000000000000000 RDI: 0000000000000000
2026-03-04T14:33:02.532461+01:00 homer kernel: [    C2] RBP: 00000000000000=
00 R08: 0000000000000000 R09: 0000000000000000
2026-03-04T14:33:02.532462+01:00 homer kernel: [    C2] R10: 00000000000000=
00 R11: 0000000000000000 R12: 0000000000000000
2026-03-04T14:33:02.532462+01:00 homer kernel: [    C2] R13: 00000000000000=
00 R14: 0000000000000000 R15: 0000000000000000
2026-03-04T14:33:02.532462+01:00 homer kernel: [    C2]  </TASK>

Bert Karwatzki

