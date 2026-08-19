Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B4CC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 17:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1666B0095; Wed, 19 Aug 2026 13:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962776B0098; Wed, 19 Aug 2026 13:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878396B009B; Wed, 19 Aug 2026 13:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5446C6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:03:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D08D01405C0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:03:57 +0000 (UTC)
X-FDA: 85118641314.02.0C83A7C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D357140010
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:03:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qxGLbODb;
	spf=none (imf23.hostedemail.com: domain of BATV+e526d06549997cf3c023+8396+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+e526d06549997cf3c023+8396+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787159036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2JPIRj5Cm1Euel970r+5c+HZVSWkuYLsHyJPoO4csg=;
	b=UzuarG10yFxNrcKkbxmkQxqiTdHRPBVbaWW+pZNpQOXbH++/JP/iVQiRrlgAKA4BgTYQQ0
	TdDj1OdgxiqyoTjG6M95U5ba/sT6UBDT257cZL/CzbObuV32UJV4v9UZGD7uX3J5o+GmcF
	/OBIjK7HOHv9KbN66l27cX6dynzpwMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787159036;
	b=VwFhfzW87hrTchTJy6M2YEMOmMxNY5EDKfe1D2+Mfl+209CQM2YtaM3XltYZcYGNba5gFk
	6qMGSnzWTEKrIksySuosMQ5NhKHIQJbFYtIZO14LPR0GgwQvzBY6/OBdA128aHCIb3zkgq
	fXMi+fdOIquNDvMoNS+1yMcgJBn6FcM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qxGLbODb;
	spf=none (imf23.hostedemail.com: domain of BATV+e526d06549997cf3c023+8396+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+e526d06549997cf3c023+8396+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X2JPIRj5Cm1Euel970r+5c+HZVSWkuYLsHyJPoO4csg=; b=qxGLbODb8bUHyyhOXdEevrYVfl
	5XJEUjT6wwIsRGsmccW2iTOJi7R09FpY3hdHrc5RiXr35f4iHwBtSqONtB7M7Rtyox6HfF5YMaZke
	SysRoSWKMjSMlayPg3ml2Quu1Bl3rdeb4udJUa/c3od5lWvz2QTcAk/OADBUIYU1i0FllLWdxP5X/
	rRngdnodoHOiTtqO4xADnNSCe5F7L3T6wsyzByfyJOyJn4gQSjD6mv3kuxXh1nLsJsSZ/EhcfWoFI
	C8il7bc/XFtgpVncOeA541aQYow3Clmtg9X1nthQSkJNKRh8OUzlK8Obi6XWz6vNjC9fCP6eL0GAh
	+UN6Ytng==;
Received: from [2001:8b0:10b:5:f6c4:be10:4885:f95e] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwjhg-0000000EA2h-1fOQ;
	Wed, 19 Aug 2026 17:03:52 +0000
Message-ID: <caf4476c54f0db4b5de8753749c89e5735886b59.camel@infradead.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-08-19
From: David Woodhouse <dwmw2@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
 "linux-coco@lists.linux.dev"	 <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM	 <kvm@vger.kernel.org>
Date: Wed, 19 Aug 2026 18:03:40 +0100
In-Reply-To: <54d375aa-8362-4e1c-8f76-bae1eb9f4f76@kernel.org>
References: <54d375aa-8362-4e1c-8f76-bae1eb9f4f76@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-B+HdHmc5L0yljg7tDt7J"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: tf1dqzhwngk99kfx5egzeid4hjnzhfzx
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D357140010
X-HE-Tag: 1787159035-600098
X-HE-Meta: U2FsdGVkX1/1GJmX3JGvjBOUIvicJ2s7AHMp6bEd7+ADuk5NMVoc5r/hOPpZ1zffch2ZrxuIABSJzsHpVVwQA4N1yUavonrQTOndM0bOvszVH2g+BaA4HEty40wnknN5pJwUJ6S4CRI4Uv/cDNZjudScRShiuJrs305+mIM56b+rr8KKl85R+LmVvt8aK/czZkWxFp8TrV9eICX3tIyDsjOQcJlWiJ8JdXzaoKBXAGyEsmupAIDz0TXP7Lpebs8tz5DnsbDUxC5s/TOsaKBOtLa+GsVYZrA1Q5HtOmxdBGru7gjABY0hy913165qH88l6SmN10v54FM6sq4qaXNNqQlPDfWNfZ9bZXipTJvi/B7neGTlwihkbLl8cZjYWQpTCWM/z6xethaDt/MpQ60173ayUOVXo8UJpkwy0QTM5pvK6lwN7OCEP31VRil4fqjGfrzAqFixp1uT9uDh635JzqqAELYWawM1MPi08efHm+8FxsX4AJykdf/ou7UNHZVYQ8Epy1kCehqdHxFxf4IB6CGGrR/LOP+InrbJCK7s576uJh7mGtegf8idbWZwijgKksSFpy4IJlKIujG7UBWQq+THW9SGIwFZJIw5DeBqXAhvI+voY5ckRR78gKyuXR8QHHRP5YELKyQ2Irs3aS3xAJUqu9D4Vst7P4L6QJR7tFwocmK4pt/UlBpd9OSSk6dv1om7pFJn9Xgp5EwtYYBaFDyiR3yRKLIAM+9l6beFGeBL6fPqSSMlxPZl0LP+eSMteqaMyOS9mCWbVf3qVbe9EU98jWWdoDNRGBoNXMweMaQK3PPrDntdA9HkQgOa8H3KE/+LQWqtfVIips1V4gOxeTyxJdAKccvw6IwIUpntkZyJdwwjmCzJ8GRiwMZ9ySrfB0ldznFbYxH1rM0ExsgLopG/PPtAZL992IZk7f5dBsB5Jom3SzE+GyPY+RxWctM2dqnLO8y/BCYj1wujRs1
 Um/euHbP
 1QhnNLemLs02UZtntPINedAAO0x5JS+h8H2KWG4bDVk815qTNCCzUvxJySG+nrrLSGLZP5uhiGauceiqV+eRrlqu/dZHPNJkjjj39WHY1qmCf1s6G+zr0QY1GwWLLY1wqOw2Pzbd2Fe/1TBLind11s2Y1tOJwrh+htdhy4XOOvcuFwdN/KWg/OaodNBlvvapHAHR+lHAM8Azj96/A3oWsKaZ8moNBiHMVnR2L/vwEVWqbeD9+X8s2OWP1jU1k+0FlK6DMiABHgpvzfHXA8t4sH8ivjQ9Plnh8mttEULh80/uead53Uo+FqvED0Lfca91gTlXycMhhtU67lWPeIO7OyqBptruBg865v95V5Hf6GPmCqfKUh1dw+UGVvSy5BdYxZpEfxnDd2vhh8pz7pT2vrfFnMAIt4tzGCB7Pt6skEj+w8Zq4orOBldoDxY6fmVHJYKmCeY2rganLeU52+FARsyxDOM65TEGAl29baRs2Zi2JT4ZoAI/PKCbaG6iMsY615VoE9I95295vZrqaEq7sc3+d0cRr0HuTLdMsQ8GI0jW/3N1iXUdhy3/cWFDb59hRFcFMr4Tjx4dU+X9CUx10328QambtXpqpCnFrjD+TKP5Q5o7Et87371iryAhRaha8IClPDRUk1nU8K+xWcgYJtB4/ZAAnt8saivNUOsF0kTOW+Dj1mwqL1U8Z+o/Mtkgdmu9QoiHHnBSKzrzCTyx7PyEwE62a3BaZ9xNZCkjLMqapoUFVG3JWepPa02ko0R+XuJ0zKY8Q2/XBIGuBymvIPxAIwqKOD8Chy8F8sQ9psXa9auk/X8wXx+rLnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-B+HdHmc5L0yljg7tDt7J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-08-19 at 18:23 +0200, David Hildenbrand (Arm) wrote:
> Hi,
>=20
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2026-08-19 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Tomorrow is Thursday 20th?

> Note that we will be skipping the meeting in two weeks (2026-09-03) as bo=
th
> Ackerley and me will be traveling. So if you have something urgent to dis=
cuss,
> please speak up :)
>=20
> In this meeting, I think we should sync on the recent developemnts regard=
ing
> in-place conversion. I don't know whether David Woodhouse will make this
> meeting, but if so, we will also talk about guest_memfd+VFIO.

I should be.

--=-B+HdHmc5L0yljg7tDt7J
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
qrKGjzwL1k0xQK8kF/RxXcgAAAAAAAA=


--=-B+HdHmc5L0yljg7tDt7J--

