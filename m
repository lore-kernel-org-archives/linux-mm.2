Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48DB5C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5A56B0088; Wed,  5 Aug 2026 09:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C976B008A; Wed,  5 Aug 2026 09:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9C66B0092; Wed,  5 Aug 2026 09:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23D566B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:30:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B76708047E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:30:53 +0000 (UTC)
X-FDA: 85067301186.17.732313A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 69E66C0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:30:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n6UwsPPP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+ef35d5f325ef5e0fcd65+8382+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+ef35d5f325ef5e0fcd65+8382+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785936652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpplnPp1w4ZCg5mqpb+PJzvSUY0M1Rme7vbzkDYnaiY=;
	b=m/W7/k5luzsxIkMx3nGBF0itltZhGLWQM4ZCc61/D+xsSUDVLqCIyhZQK18Gq6yAAQQMOE
	/KKpSoEiJz/FTU1Pvj3dttE2g2pKOxfSmR6MiNI6OovPQ607WwzwYjxstaqGTopTlbs2cO
	4Avyd+3KjlCMEB7/+dCdxR4cRfvBnfE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n6UwsPPP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+ef35d5f325ef5e0fcd65+8382+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+ef35d5f325ef5e0fcd65+8382+infradead.org+dwmw2@casper.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785936652;
	b=2Vs07W562By3Y7zUONU3ABoT9BdARjcHN4K+vB/mbLSfTwe7YQvhfmJk8bMa1c/TwqsqfR
	qYmRe0RKnJSDzMKuK6siuN7x6Y8CdvSlOTzASv3e2bcUVnG0srsNFU9k69QV3lgQnKoyLG
	5Dufk/wLq60VNkoL7pZEP6N0OXqTXlY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WpplnPp1w4ZCg5mqpb+PJzvSUY0M1Rme7vbzkDYnaiY=; b=n6UwsPPP4LnyI39Wfug45QjILc
	G1vkzIA5Gst5mQgAqBUHIX6y/Zttkp2vWW59igj9Mb+X/HHXGYz6RIjHMDchWLOLIG5u5ycp4paNa
	qGpA37o7vy1nYSbvaM5BS2Z4fi38eLQWP+/zsQbYqimjqGtd5i5FzC572beels3LA2aSaokq81INK
	ZEHlRz6ICV/uXpWe+f2BBaE/P7DBiiimQp2Obos9oLBLIf9z286YCIuJwiZq1RHhyKRWhETm1x19/
	X3ScBzR1StctdRBvuauR5r1k4XqJeyIU9iWWFKjdB8zf3jVswCtXp+CZslDyAIzFSX2Eq/nDWBq3i
	my56jE4g==;
Received: from [2a07:aa00:8c:e0:2ef0:7ea2:4f15:3280] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrbhm-000000040A1-3U05;
	Wed, 05 Aug 2026 13:30:47 +0000
Message-ID: <da208f1768c25d9adaf0b9bb820c7fd51bed3373.camel@infradead.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-08-06
From: David Woodhouse <dwmw2@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
 "linux-coco@lists.linux.dev"	 <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM	 <kvm@vger.kernel.org>
Date: Wed, 05 Aug 2026 15:30:52 +0200
In-Reply-To: <69806089-f615-490a-8367-cfea21fb0854@kernel.org>
References: <69806089-f615-490a-8367-cfea21fb0854@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-18o4oxbSF88pGeg87UqE"
User-Agent: Evolution 3.60.3-0ubuntu1~ppa9~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69E66C0006
X-Stat-Signature: 3x1zes4wgae9g6s9fs3gykf8ad4bynx9
X-Rspam-User: 
X-HE-Tag: 1785936649-922082
X-HE-Meta: U2FsdGVkX1/Y6a0iDAGRF7ikE7T19KIY7/nXgXz1SwErJTRfpsjmQ2vwJ0oW9mXNiLBmq95tBWkjgliCvQ7Zz7knUQEZRC1zf3TH0cOCt/28Aycb5kNQMwDk3H8rU5EfIOFHnRR0tdCYzS/8MHczk4q0ha3dZL42es0PgxsNxr5olQkwY/Z1yPqfBqQd8gKOdGqYyoOPoVgL7uKl9Q66gQoweUqcT9tnX24WpTMa4GrRRz1s1Nbzxf5p1ziTKWY4+WO8BksTWA23CU+JsbHvutm4R/19DH+bxNl0c/vaOi4MiSoYvODo3i5MW9uhnoXRjQ0Gh/zbtJOvQueQUsPHsg7sCeXkUPe0rxezmT3RPF7kFa4cMo9005Nya00q67FNs7ypJPrIZFpxtwCAXQhnqo9lNa8t4Nep4QlnG7KbrRbBFi6odn7hS+JyEHJMy31BFHqFkgXdgK4T6z0CWnsowm1HKBly9T75sV1i3TxtfE4itpR2/+wa0JkRhARpjpPVQDP4Hp6IVo/AzRGjH2j82P8mSZjR4g7Vj/lNvFuW7SmAAh2EfhtA0y1is30jKbmeKYEgSKVxojgb31YqZPLmcXuSKb8fdoZCI65CEnsf+ScINZdZEOGPvrZVm/F+5x6ii31eW2LgaCY8LScbGQXMkbFkitYw6cDnd9AoD4tNbt1e09a38YT+j20iWZYOoRbyv6wNYNgtHncLsRJQ6SOfzigjjixay/zRSSlipn0pFYs20z3NEAqhoKWuAGYiAqX9ajS+mixU2Mhm6+JwtIZTLTBTbaZUsG8ByUrcwj9B6npDspNM42hsaemTx3lTMC0spsSpxH8MNawfn8NIyP61xdUS/cfBtuTc9BGMCYinIars7uowDX9AntA/Y0ZVoWY1uYZ3qaroor9rJqeKEo0Bboz4j5t6nf4JdtrrdboNSPYnyf8Bbn+AkjklTyTZ1Grj2XvQ8PBtn2JSD7RxW3w
 Qy/ggXni
 YfDK4an7BycH/oDOtJD6NSEn+t7O+O4++/f3Fzcb1ZmkFw6Y26qjjdMgyU/ROJL43DCbvb9zbNxH5f7HIVtYHMR7YjLntElJnruEJJ6cb9grepAZy+pdwyZ72TcO/cbf0tdDmjdtVVRHWaOUYHQZbi3g2CDCOikcj/ZKwdwT0Jevm2TeXc9NcwXnVcvDxpyqlRbARDBKrsk9uSiTDq27eJZBIlMQfjrnViP4iF/pLoxCsRZ7XbFmrUE64I1QUB49lvYqzev9F+N4/ttWqyrx0sHqdnayJh4f2knANAXAvnOWWcbY5CJasDz2R7EVkVRT8zoC1Q64uouu4Yfz7C3qRNeThPHH1IasR1Tn2E0C5QBYLREK13AIEAtjN2RckzzPeYfgzZvp0PQ/XPz/Yqif+LNbNTNR5lJ0kL1oh6kGYc+1ggRVqL82kbVQE41CDLUrUzt36oJsNrU7Hp8kvWDTsvcuEw+EoVB3qh69wPvT9J63ANH9sE+3sS5Kh3JPShOs7FWo1f5TIFswLTqAoaIdUeTnSJ79T5Y52VvUIXQr4CiYKgv/IAK0eB+T9QxP5BKZqd4ikKIZPqHJPnFICp55v6MaH8vBmGeqcapQyn5sG/UgK44u1GPWdTFf3yaNMDDp2/BOkc0k+v5SRgVjvUlU3TkW6IHDvr03yDnOvSETzS7Oss/LGj84a1hRHtZ4R/6pA4lCaIhv8iL+teNkYhkoDqcrwxHuF1OPO7eV4YYmHUznq/PQPfMFCxCXZVXy+8Y2zowPNoThjlzQ1qO1DATXb8bywZfgStUHHf0qmPkkBl5bSrHk+9K3ixgOycWKrNEbSiSaRhNK4nV5NbsTUVXTeQIlCFyXcjCgdkdzfRgaI+pqpodRK0jMw1nbNiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-18o4oxbSF88pGeg87UqE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-08-04 at 21:29 +0200, David Hildenbrand (Arm) wrote:
> Hi,
>=20
> Our next guest_memfd upstream call is scheduled for today, Thursday,
> 2026-08-06 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
>=20
> In this meeting, David Woodhouse wants to discuss a solution to get VFIO =
flying
> with guest_memfd (I suppose now also for private memory! :) ), and we sho=
uld
> sync on upstreaming of in-place conversion (and how to deal with LRU cach=
e
> draining).

Sadly I'm not 100% sure I'll make it, although I'll try.

I've not found much time to work on this since posting v2; one thing I
did manage was to add some support for memory overcommit; taking pages
away and then reconstituting them on demand with async #PF in the
guest.

https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3D894=
dd0fcb34

Then I went down a rabbithole trying to remove individual pages from
the IOMMU on Arm64, which I think I need to shelve for now and tackle
as a separate project. It worked out OK on Intel and AMD.


--=-18o4oxbSF88pGeg87UqE
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
eMG1/kE9BQ+Zhl4ggyPEtUEAAAAAAAA=


--=-18o4oxbSF88pGeg87UqE--

